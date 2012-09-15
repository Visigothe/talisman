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

      describe 'failure' do 
      before do
        visit new_user_registration_path
        click_button 'Sign up'
      end
      it 'does not create a user' do
        expect { response.should_not change(User, :count) }
      end
      # Re-renders signup form with error message
      heading_and_title('Sign Up', 'Sign Up')
      it { should have_selector('.alert-error') }
      it { should have_content(I18n.t('simple_form.error_notification.default_message')) }
      # Tests for Devise :validatatble cover the indivual cases for signup failure (i.e. no email)
    end

    describe 'success' do 
      before { signup user }
      it 'creates a user' do
        expect { response.should change(User, :count).by(1) }
      end
      # Redirects to root_path with success messgae
      # Customized redirect in will require change of heading and title
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
      heading_and_title('Editing', 'Edit Account')
      it { should have_selector('label', text: 'Email') }
      it { should have_selector('input#user_email') }
      it { should have_selector('label', text: 'Password') }
      it { should have_selector('input#user_password') }
      it { should have_selector('label', text: 'Password confirmation') }
      it { should have_selector('input#user_password_confirmation') }
      it { should have_selector('label', text: 'Current password') }
      it { should have_selector('input#user_current_password') }
      it { should have_button('Update') }
      it { should have_selector('h2', text: 'Cancel my account') }
      it { should have_link('Cancel my account') }
    end

    describe 'failure' do

      context 'with missing current password' do
        before { click_button 'Update' }
        # Re-renders the Edit form with error message
        heading_and_title('Editing', 'Edit Account')
        it { should have_selector('.alert-error') }
        it { should have_content(I18n.t('simple_form.error_notification.default_message')) }
      end

      context 'with new password mismatch' do
        before do
          fill_in 'Password', with: 'newpassword'
          fill_in 'Password confirmation', with: 'mismatch'
          click_button 'Update'
        end
        # Re-renders the Edit form with error message
        heading_and_title('Editing', 'Edit Account')
        it { should have_selector('.alert-error') }
        it { should have_content(I18n.t('simple_form.error_notification.default_message')) }        
      end
    end

    describe 'success' do

      context 'in general' do
        before do
          fill_in 'Current password', with: user.password
          click_button 'Update'
        end
        # Re-directs to root path with success message
        # Customizing the redirect will require changing the heading and title
        heading_and_title('Talisman', '')
        it { should have_selector('.alert-success') }
        it { should have_content(I18n.t('devise.registrations.updated')) }
      end

      context 'updating password' do
        before do
          fill_in 'Password', with: 'newpassword'
          fill_in 'Password confirmation', with: 'newpassword'
          fill_in 'Current password', with: user.password
          click_button 'Update'
        end
        # Re-directs to root path with success message
        # Customizing the redirect will require changing the heading and title
        heading_and_title('Talisman', '')
        it { should have_selector('.alert-success') }
        it { should have_content(I18n.t('devise.registrations.updated')) }
      end

      context 'updating email' do
        before do
          fill_in 'Email', with: 'email@new.com'
          fill_in 'Current password', with: user.password
          click_button 'Update'
        end
        # Redirects to root with success message
        heading_and_title('Talisman', '')
        it { should have_selector('.alert-success') }
        it { should have_content(I18n.t('devise.registrations.update_needs_confirmation')) }
        # Tests for reconfirmation email are in confirmations spec
      end
    end
  end

  describe 'cancellation' do 

    let(:user) { FactoryGirl.create(:user) }

    before do 
      confirm_and_signin user
      visit edit_user_registration_path
    end

    describe 'link' do 

      it { should have_link('Cancel my account', ) }

      context 'when clicked' do 
        before { click_link 'Cancel my account' }
        it 'deletes the user' do
          expect { response.should change(User, :count).by(-1) }
        end
      end
    end
  end  
end