# Devise :confirmable
require 'spec_helper'

describe 'Confirmation' do

	subject { page }

  describe 'email is sent after signup' do
    let(:user) { FactoryGirl.build(:user) }
    before do 
      visit new_user_registration_path
      signup user
		end
		# Tests for signed_up_but_unconfirmed flash message are in registrations_spec
		specify { Devise::Mailer.deliveries.last.to.should include(user.email) }
		specify { Devise::Mailer.deliveries.last.subject.should include(I18n.t('devise.mailer.confirmation_instructions.subject')) }
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
		specify { Devise::Mailer.deliveries.last.subject.should include(I18n.t('devise.mailer.confirmation_instructions.subject')) }
	end

  describe 'email' do
  	pending 'Fill in tests for confirmation email'
  end

  context 'failure when already confirmed' do
    pending 'Fill in tests for confirmation failure when the user is already confirmed'  	  
  end

  context 'success' do 
  	pending 'Fill in tests for confirmation success'
  end

  describe 'after changing email' do 
  	pending 'Fill is tests for email reconfirmation'
  end
end