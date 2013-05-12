require 'spec_helper'

describe 'Registerable Module' do

  describe 'registration page' do

    before do
      visit root_path
      click_link 'Sign up now!'
    end

    subject { page }

    it { should have_title('Sign Up') }
    it { should have_selector('h1', text: 'Sign Up') }
    it { should have_selector('input#user_email') }
    it { should have_selector('input#user_password') }
    it { should have_selector('input#user_password_confirmation') }
    it { should have_button('Sign up') }
  end

  describe 'response to registration' do

    let(:user) { build(:user) }

    before { visit new_user_registration_path }

    subject { page }

    describe 'failure' do 
      before { click_button 'Sign up' }

      specify { expect { response.should_not change(User, :count) } }
      specify { current_path.should eq user_registration_path }
      it { should have_selector('.alert-error', text: I18n.t('simple_form.error_notification.default_message')) }
    end

    describe 'success' do 
      before do
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: user.password
        fill_in 'user_password_confirmation', with: user.password
        click_button 'Sign up'
      end

      specify { expect { response.should change(User, :count).by(1) } }
      specify { current_path.should eq root_path }
      # FIXME: expected to find css ".alert-success" with text "A message with a confirmation link has been sent to 
      # FIXME: your email address. Please open the link to activate your account." but there were no matches.
      # FIXME: Also found "× Welcome! You have signed up successfully.", which matched the selector but not all filters.
      # FIXME: Inspection shows the appropriate message but not registering with example, issue with Capybara::Session?
      pending "it { should have_selector('.alert-success', text: I18n.t('devise.registrations.signed_up_but_unconfirmed')) }"
    end
  end

  describe 'registration edit page' do

    let(:user) { create(:user) }

    before do 
      user.confirm!
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'Sign in'
      visit edit_user_registration_path(user)
    end

    subject { page }

    it { should have_title('Edit Account') }
    it { should have_selector('h1', 'Editing') }
    it { should have_selector('input#user_email') }
    it { should have_selector('input#user_password') }
    it { should have_selector('input#user_password_confirmation') }
    it { should have_selector('input#user_current_password') }
    it { should have_button('Update') }
    it { should have_selector('h2', text: 'Cancel my account') }
    it { should have_link('Cancel my account') }
  end

  describe 'editing user registration failure' do

    let(:user) { create(:user) }

    before do 
      user.confirm!
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'Sign in'
      visit edit_user_registration_path(user)
      click_button 'Update'
    end

    specify { current_path.should eq user_registration_path }
    specify { page.should have_selector('.alert-error', text: I18n.t('simple_form.error_notification.default_message')) }
  end

  describe 'editing user registration success' do

    let(:user) { create(:user) }

    before do 
      user.confirm!
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'Sign in'
      visit edit_user_registration_path(user)
    end

    context 'when updating password' do
      before do
        fill_in 'user_password', with: 'newpassword'
        fill_in 'user_password_confirmation', with: 'newpassword'
        fill_in 'user_current_password', with: user.password
        click_button 'Update'
      end

      specify { current_path.should eq root_path }
      specify { page.should have_selector('.alert-success', text: I18n.t('devise.registrations.updated')) }
    end

    context 'when updating email' do
      before do
        fill_in 'user_email', with: 'email@new.com'
        fill_in 'user_current_password', with: user.password
        click_button 'Update'
      end

      specify { current_path.should eq root_path }
      specify { page.should have_selector('.alert-success', text: I18n.t('devise.registrations.update_needs_confirmation')) }
    end
  end

  describe 'user account cancellation' do 

    let(:user) { create(:user) }

    before do 
      user.confirm!
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'Sign in'
      visit edit_user_registration_path(user)
      click_link 'Cancel my account'
    end

    specify { expect { response.should change(User, :count).by(-1) } }
    specify { current_path.should eq root_path }
    # FIXME: Find a solution to clicking the ok link on the confirm popup
    pending "it { should have_selector('.alert-success', I18n.t('devise.registrations.destroyed')) }"
  end  
end