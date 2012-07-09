# Devise :confirmable
require 'spec_helper'

describe 'Confirmation' do

	subject { page }

  before { signup_someone }
  let(:user) { User.find_by_email('someone@example.com') }

  describe 'email is sent after signup' do
		specify { Devise::Mailer.deliveries.last.to.should include(user.email) }
    # Sets confirmation_token and confirmation_sent_at
    specify { user.confirmation_token.should_not be_nil }
    specify { user.confirmation_sent_at.should_not be_nil }
    # Tests for signed_up_but_unconfirmed flash message are in registrations_spec
	end

  describe 'resend confirmation instructions page' do 
    before { visit new_user_confirmation_path }
    heading_and_title('Resend confirmation instructions', 'Resend Confirmation')
    it { should have_selector('label', text: 'Email') }
    it { should have_selector('input#user_email') }
    it { should have_button('Resend confirmation instructions')}
  end

	describe 'email is sent after resend confirmation instructions request' do
		before do 
			visit new_user_confirmation_path
			fill_in 'Email', with: user.email
			click_button 'Resend confirmation instructions'
		end
		# Redirects to root_path with success message
		heading_and_title('Talisman', '')
		it { should have_selector('.alert-success') }
		it { should have_content(I18n.t('devise.confirmations.send_instructions')) }
		specify { Devise::Mailer.deliveries.last.to.should include(user.email) }
    # Sets confirmation_token and confirmation_sent_at
    specify { user.confirmation_token.should_not be_nil }
    specify { user.confirmation_sent_at.should_not be_nil }
	end

  describe 'email' do
    let(:email) { Devise::Mailer.deliveries.last }
    # It is to user from talisman@example.com and has content and link
    specify { email.to.should include(user.email) }
    specify { email.from.should include('talisman@example.com') }
    specify { email.subject.should include(I18n.t('devise.mailer.confirmation_instructions.subject')) }
    specify { email.should have_content('You can confirm your account email through the link below:') }
    specify { email.should have_link('Confirm my account') }
  end

  context 'failure when user is already confirmed' do
    describe 'redirects to signin with error message' do 
      before do
        user.confirm!
        visit user_confirmation_path(user.confirmation_token)
      end
      heading_and_title('Sign In', 'Sign In')
      it { should have_selector('.alert-error') }
      it { should have_content(I18n.t('devise.confirmations.already_confirmed')) }
    end
  end

  context 'success' do 
    before { visit user_confirmation_path(user.confirmation_token) }
    # Confirms user and redirects to profile with success message
    specify 'user.confirmed?.should be_true'
    it "heading_and_title(user.email, 'Profile')"
    it "should have_selector('.alert-success')"
    it "should have_content(I18n.t('devise.confirmations.confirmed'))"
  end

  describe 'after changing email' do 
  	before do 
      confirm_and_signin user
      visit edit_user_registration_path
      fill_in 'Email', with: 'anotherone@example.com'
      fill_in 'Current password', with: user.password
    end
    # Sets unconfirmed_email and confirmation_sent_at
    specify "user.confirmation_sent_at.should_not be_nil"
    specify "user.unconfirmed_email.should == 'anotherone@example.com'"

    describe 'a reconfirmation email is sent' do 
      let(:email) { Devise::Mailer.deliveries.last }
    # It is to user from talisman@example.com and has content and link
      specify "{ email.to.should include(user.email) }"
      specify "{ email.from.should include('talisman@example.com') }"
      specify "{ email.subject.should include(I18n.t('devise.mailer.confirmation_instructions.subject')) }"
      specify "{ email.should have_content('You can confirm your account email through the link below:') }"
      specify "{ email.should have_link('Confirm my account') }"
    end
  end
end