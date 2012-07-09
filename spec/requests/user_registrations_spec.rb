# Devise :registerable
require 'spec_helper'

describe 'Registration' do

  subject { page }

  describe 'signup' do 

    let(:user) { FactoryGirl.build(:user) }

    before { visit new_user_registration_path }

    describe 'form' do 
      before { visit new_user_registration_path }
      heading_and_title('Sign Up', 'Sign Up')
      it { should have_selector('label', text: 'Email') }
      it { should have_selector('input#user_email') }
      it { should have_selector('label', text: 'Password') }
      it { should have_selector('input#user_password') }
      it { should have_selector('label', text: 'Password confirmation') }
      it { should have_selector('input#user_password_confirmation') }
      it { should have_button('Sign up') }
    end

    context 'failure' do 
      before do
        visit new_user_registration_path
        click_button 'Sign up'
      end
      it 'does not create a user' do
        expect { response.should_not change(User, :count) }
      end
      # Re-renders signup form
      heading_and_title('Sign Up', 'Sign Up')
      it { should have_selector('.alert-error') }
      it { should have_content(I18n.t('simple_form.error_notification.default_message')) }
      # Tests for Devise :validatatble cover the indivual cases for signup failure (i.e. no email)
    end

    context 'success' do 
      before { signup user }
      it 'creates a user' do
        expect { response.should change(User, :count).by(1) }
      end
      # Redirects to root_path
      # Customized redirect in registrations controller will require change of heading and title
      heading_and_title('Talisman', '')
      it { should have_selector('.alert-success') }
      it { should have_content(I18n.t('devise.registrations.signed_up_but_unconfirmed')) }
      # Tests for the confirmation email are in confirmations_spec
    end
  end

  describe 'editing' do 

    let(:user) { FactoryGirl.create(:user) }

    before do 
      confirm_and_signin user
      visit edit_user_registration_path
    end

    describe 'form' do 
      pending 'Fill in the tests for form fields'
    end

    context 'failure' do 
      pending 'Fill in the tests for editing failure'
    end

    context 'success' do 
      pending 'Fill in the tests for editing success'
    end

    context 'email' do
      # Redirects to root with success message
      it "heading_and_title('Talisman', '')"
      it "{ should have_selector('.alert-success') }"
      it "{ should have_content(I18n.t('devise.registration.update_needs_confirmation') }"
      # Tests for reconfirmation email are in confirmations spec     
    end
  end

  describe 'cancellation' do 

    let(:user) { FactoryGirl.create(:user) }

    before do 
      confirm_and_signin user
      visit edit_user_registration_path
    end

    describe 'link' do 

      it 'is part of the registration edit form' do
        pending 'Fill in tests for cancellation link'       
      end

      context 'when clicked' do 
        pending 'Fill in tests for when cancellation link is clicked'
      end
    end
  end  
end