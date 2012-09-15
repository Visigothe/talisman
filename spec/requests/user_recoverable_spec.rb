require 'spec_helper'

describe 'Recoverable' do
  
  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  before { user.confirm! }

  describe 'new password page' do
    before { visit new_user_password_path } 
    heading_and_title('Forgot your password?', 'Forgotten Password')
    it { should have_selector('input#user_email') }
    it { should have_button('Send me reset password instructions') }

    describe 'clicking the reset button' do 
      before do 
        fill_in 'Email', with: user.email
        click_button 'Send me reset password instructions'        
      end
      it 'sends an email' do
        expect { response.should send_email(user.email) }
      end
      # Redirects to signin with success message
      heading_and_title('Sign In', 'Sign In')
      it { should have_selector('.alert-success') }
      it { should have_content(I18n.t('devise.passwords.send_instructions')) }
    end
  end

  describe 'password reset' do
    before { user.send_reset_password_instructions }

    describe 'request' do
      # Generates reset token and sets reset sent at
      specify { user.reset_password_token.should_not be_blank }
      specify { user.reset_password_sent_at.should_not be_blank }
      it 'sends an email' do
        expect { response.should send_email(user.email) }
      end
    end

    describe 'email' do 
      let(:email) { Devise::Mailer.deliveries.last }
      specify { email.to.should include(user.email) }
      it 'is from talisman@example.com' do
        email.from.should include('talisman@example.com')
      end
      it 'has subject' do
        email.subject.should include(I18n.t('devise.mailer.reset_password_instructions.subject'))
      end
      it 'has the user email address in the body' do
        email.should have_content("Hello #{user.email}")
      end
      it 'has content' do
        email.should have_content('Someone has requested a link to change your password')
        email.should have_content("If you didn't request this, please ignore this email.")
        email.should have_content("Your password won't change until you access the link above and create a new one.")
      end
      it 'has a link' do
        email.should have_link('Change my password')
      end
    end

    describe 'view' do 

      before { visit edit_user_password_path(user.reset_password_token) }
      heading_and_title('Change your password', 'Reset Password')
      it { should have_selector('input#user_password') }
      it { should have_selector('input#user_password_confirmation') }
      it { should have_button('Change my password') }
    end

    describe 'failure' do 

      before do 
        visit edit_user_password_path(user.reset_password_token)
        click_button 'Change my password'
      end
      # Re-renders the reset password page with error message
      heading_and_title('Change your password', 'Reset Password')
      it { should have_selector('.alert-error') }
      it { should have_content(I18n.t('simple_form.error_notification.default_message'))}
    end

    describe 'success' do 

      before do 
        visit edit_user_password_path(user.reset_password_token)
        fill_in 'New password', with: 'newpassword'
        fill_in 'Confirm your new password', with: 'newpassword'
        click_button 'Change my password'
      end
      # Redirects to root with success message and signs in the user
      heading_and_title('Talisman', '')
      it { should have_selector('.alert-success') }
      it { should have_content(I18n.t('devise.passwords.updated')) }
      specify 'logs the user in' do 
        expect { user_signed_in?.should be_true }
      end
    end
  end
end