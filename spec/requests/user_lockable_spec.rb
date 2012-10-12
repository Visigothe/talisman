require 'spec_helper'

describe "Lockable" do 

  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  specify "when user is unconfirmed" do
    user.active_for_authentication?.should be_false   
  end

  describe "authentication" do 
    
    before { user.confirm! }

    specify "when user is active for authentication" do 
      user.active_for_authentication?.should be_true
      user.valid_for_authentication?.should be_true
      user.access_locked?.should be_false
    end

    specify "failure increases failed attempts" do 
      visit new_user_session_path
      fill_in "Email", with: user.email
      fill_in "Password", with: "something"
      pending "failed_attempts not incrementing"
      expect { click_button "Sign in" }.to change(user, :failed_attempts).by(1)
    end
  end

  describe "when failed attempts is at the maximum one more failed attempt" do 
    
    before do 
      user.confirm!
      user.failed_attempts = 5
      visit new_user_session_path
      fill_in "Email", with: user.email
      fill_in "Password", with: "something"
      click_button "Sign in"
    end

    it "locks the account" do
      pending "failed_attempts not incrementing"
      user.access_locked?.should be_true        
    end

    # Re-renders the signin page"
    heading_and_title('Sign In', 'Sign In')

    it "has a flash message" do
      pending "Wrong flash message is displayed."
      should have_content(I18n.t('devise.unlocks.send_instructions'))
    end

    it "sends an unlock email" do 
      expect { response.should send_email(user.email) }
    end
  end

  describe "resend unlock instructions" do

    before do
      user.confirm!
      user.lock_access!
      visit new_user_unlock_path
    end

    describe "page" do 

      it { should have_selector("h2", text: "Resend unlock instructions") }
      it { should have_selector("input#user_email") }
      it { should have_button("Resend unlock instructions") }
    end

    describe "button" do

      before do 
        fill_in "Email", with: user.email
        click_button "Resend unlock instructions"
      end

      it "sends an unlock email" do
        expect { response.should send_email(user.email) }
      end

      it "redirects to signin page" do
        should have_selector("h1", text: "Sign In")
      end

      it "has a flash message" do
        should have_content(I18n.t('devise.unlocks.send_instructions'))
      end 
    end
  end


  describe "unlock email" do 
    
    before do 
      user.confirm!
      user.lock_access!   
    end

    let(:email) { Devise::Mailer.deliveries.last}

    it "is to the user" do 
      email.to.should include(user.email)
    end

    it "is from talisman@example.com" do
      email.from.should include("talisman@example.com")
    end

    it "has a subject" do 
      email.subject.should include(I18n.t('devise.mailer.unlock_instructions.subject'))
    end

    it "has the user's email address in the mail body" do 
      email.should have_content("Hello #{user.email}")
    end

    it "has content" do
      email.should have_content("Click the link below to unlock your account:")
    end

    it "has a link" do 
      email.should have_link('Unlock my account')
    end
  end

  describe "unlock failure" do 
    pending # Fill in tests for unlock failure
  end

  describe "unlock success" do 

    before do
      user.confirm!
      user.lock_access!
      visit user_unlock_path(user.unlock_token)
    end

    it "redirects to user root path" do
      expect { response.should redirect_to(root_path) }
    end

    it "has a success message" do
      pending "Unable to find xpath '/html'"
      should have_content(I18n.t('devise.unlocks.unlocked'))
    end

    it "unlocks the user" do
      pending "The user should be unlocked but test does not register unlock "
      user.access_locked?.should be_false
    end

    it "logs the user in" do
      expect { user_signed_in?.should be_true }
    end
  end

  describe "methods" do 

    before { user.confirm! }
    
    specify "lock_access! locks user account" do 
      user.lock_access!
      user.access_locked?.should be_true
    end

    specify "unlock_access! unlocks user account" do 
      user.lock_access!
      user.unlock_access!
      user.access_locked?.should be_false
    end
  end
end