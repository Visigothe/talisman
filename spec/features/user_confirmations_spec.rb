require 'spec_helper'

describe 'Confirmable Module' do

  describe 'response after registration' do

    before do
      Devise::Mailer.deliveries.clear
      visit new_user_registration_path
      fill_in 'user_email', with: 'user@example.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      Timecop.freeze
      click_button 'Sign up'
    end

    subject { User.find_by_email('user@example.com').reload }

    its(:confirmation_token) { should_not be_nil }
    its(:confirmation_sent_at) { should eq Time.now }
    specify { Devise::Mailer.deliveries.size.should eq 1 }
    specify { current_path.should eq root_path }
    specify { page.should have_selector('.alert-success') }
    # TODO: move content for success message into selector block when resolved
    # FIXME: expected content "A message with a confirmation link has been sent to your email address. 
    # FIXME: Please open the link to activate your account." but there were no matches. 
    # FIXME: Also found "× Welcome! You have signed up successfully.", which matched the selector but not all filters.
    # FIXME: Inspection shows the appropriate message but not registering with example, issue with Capybara::Session?
    pending "it { page.should have_content(I18n.t('devise.registrations.signed_up_but_unconfirmed')) }"
	end

  describe 'resending confirmation instructions page' do

    before do
      visit new_user_session_path
      click_link "Didn't receive confirmation instructions?"
    end

    subject { page }

    it { should have_title('Resend Confirmation') }
    it { should have_selector('h1', text: 'Resend confirmation instructions') }
    it { should have_selector('input#user_email') }
    it { should have_button('Resend confirmation instructions') }
  end

  describe 'response after clicking "Resend confirmation instructions" button' do

    let(:user) { create(:user) }

    before do
      visit new_user_confirmation_path
      fill_in 'user_email', with: user.email
    end

    context 'for the unconfirmed user' do

      before do
        Devise::Mailer.deliveries.clear
        Timecop.freeze
        click_button 'Resend confirmation instructions'
      end

      subject { user.reload }

      its(:confirmation_token) { should_not be_nil }
      its(:confirmation_sent_at) { should eq Time.now }
      specify { Devise::Mailer.deliveries.count.should eq 1 }
      specify { current_path.should eq new_user_session_path }
      specify { page.should have_selector('.alert-success', text: I18n.t('devise.confirmations.send_instructions')) }
    end

    context 'for the confirmed user' do

      before do
        Devise::Mailer.deliveries.clear
        user.confirm!
        click_button 'Resend confirmation instructions'
      end

      subject { page }

      specify { Devise::Mailer.deliveries.count.should eq 0 }
      specify { current_path.should eq user_confirmation_path }
      it { should have_selector('.alert-error', text: I18n.t('simple_form.error_notification.default_message')) }
      # TODO: Figure out why translation is missing for I18n.t('devise.errors.messages.already_confirmed')
      # TODO: text in example in the same as what is in devise.en.yml
      it { should have_selector('.help-inline', text: 'was already confirmed, please try signing in') }
    end
  end

  describe 'response to confirmation failure' do

    let(:user) { create(:user) }

    context 'when confirmation token is invalid' do
      before { visit user_confirmation_path(confirmation_token: 'invalid') }

      subject { user.reload }

      its(:confirmed_at) { should be_nil }
      its(:confirmed?) { should be_false }
      specify { current_path.should eq user_confirmation_path }
      # TODO: customize to be more specific, i.e. unable to confirm account, please request a new one
      specify { page.should have_selector('.alert-error', text: I18n.t('simple_form.error_notification.default_message')) }
    end

    context 'when user is already confirmed' do
      before do
        user.confirm!
        visit user_confirmation_path(confirmation_token: user.confirmation_token)
      end

      subject { page }

      specify { current_path.should eq user_confirmation_path }
      specify { page.should have_selector('.alert-error', text: I18n.t('simple_form.error_notification.default_message')) }
      # TODO: No information is given to the confirmed user about why confirmation failed.
      # TODO: Customize behavior to get pending example to pass
      # TODO: Figure out why translation is missing for I18n.t('devise.errors.messages.already_confirmed')
      # TODO: text in example in the same as what is in devise.en.yml
      pending "specify { page.should have_selector('.help-inline', text: 'was already confirmed, please try signing in') }"
    end
  end

  describe 'response to confirmation success' do

    let(:user) { create(:user) }

    before do
      user.send_confirmation_instructions
      Timecop.freeze
      visit user_confirmation_path(confirmation_token: user.confirmation_token)
    end

    subject { user.reload }

    its(:confirmed_at) { should eq Time.now }
    its(:confirmed?) { should be_true }
    specify { expect { user_signed_in?.should be_true } }
    specify { current_path.should eq root_path }
    specify { page.should have_selector('.alert-success', text: I18n.t('devise.confirmations.confirmed')) }
  end

  describe 'response to changing email' do

    let(:user) { create(:user) }

  	before do 
      user.confirm!
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'Sign in'
      Timecop.freeze
      Devise::Mailer.deliveries.clear
      visit edit_user_registration_path(id: user.id)
      fill_in 'user_email', with: 'anotherone@example.com'
      fill_in 'user_current_password', with: user.password
      click_button 'Update'
    end

    subject { user.reload }

    its(:confirmation_sent_at) { should eq Time.now }
    its(:confirmation_token) { should_not be_nil }
    its(:unconfirmed_email) { should eq 'anotherone@example.com' }
    specify { Devise::Mailer.deliveries.count.should eq 1 }
    specify { current_path.should eq root_path }
    it { page.should have_selector('.alert-success') }
    it { page.should have_content(I18n.t('devise.registrations.update_needs_confirmation')) }
  end

  describe 'confirmation email' do
    # TODO: Move this to a more appropriate spot, perhaps devise_email_spec.rb?

    let(:user) { create(:user) }
    
    subject { Devise::Mailer.deliveries.last }

    its(:to) { should include(user.email) }
    its(:from) { should include('talisman@example.com') }
    its(:subject) { should include(I18n.t('devise.mailer.confirmation_instructions.subject')) }
    its(:body) { should have_link('Confirm my account') }
  end
end
