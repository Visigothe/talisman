# Devise :confirmable
require 'spec_helper'

describe 'Confirmation' do

	subject { page }

  describe 'email is sent after signup' do
    before { signup_someone }
    let(:user) { User.find_by_email('someone@example.com') }
		# Tests for signed_up_but_unconfirmed flash message are in registrations_spec
		specify { Devise::Mailer.deliveries.last.to.should include(user.email) }
    specify { user.confirmation_token.should_not be_nil }
	end

  describe 'resend confirmation instructions page' do 
    before { visit new_user_confirmation_path }
    heading_and_title('Resend confirmation instructions', 'Resend Confirmation')
    it { should have_selector('label', text: 'Email') }
    it { should have_selector('input#user_email') }
    it { should have_button('Resend confirmation instructions')}
  end

	describe 'email is sent after resend confirmation instructions request' do
		let(:user) { FactoryGirl.create(:user) }
		before do 
			visit new_user_confirmation_path
			fill_in 'Email', with: user.email
			click_button 'Resend confirmation instructions'
		end
		# Redirects to root_path
		heading_and_title('Talisman', '')
		it { should have_selector('.alert-success') }
		it { should have_content(I18n.t('devise.confirmations.send_instructions')) }
		specify { Devise::Mailer.deliveries.last.to.should include(user.email) }
	end

  describe 'email' do
    let(:user) { FactoryGirl.create(:user) }
    before { signup user }
    let(:email) { Devise::Mailer.deliveries.last }
    specify { email.to.should include(user.email) }
    specify { email.from.should include('talisman@example.com') }
    specify { email.subject.should include(I18n.t('devise.mailer.confirmation_instructions.subject')) }
    specify { email.should have_content('You can confirm your account email through the link below:') }
    specify { email.should have_link('Confirm my account') }
  end

  context 'failure when already confirmed' do
    before { signup_someone }
    let(:user) { User.find_by_email('someone@example.com') }
    describe 'redirects to signin' do 
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
  	pending 'Fill in tests for confirmation success'
  end

  describe 'after changing email' do 
  	pending 'Fill is tests for email reconfirmation'
  end
end