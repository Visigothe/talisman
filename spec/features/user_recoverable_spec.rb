require 'spec_helper'

describe 'Recoverable Module' do

  let(:user) { create(:user) }

  before { user.confirm! }

  describe 'new password page' do

    before { visit new_user_password_path }

    subject { page }

    it { should have_title('Forgotten Password') }
    it { should have_selector('h1', text: 'Forgot your password') }
    it { should have_selector('input#user_email') }
    it { should have_button('Send me reset password instructions') }
  end

  describe 'response to clicking "Send me reset password instructions"' do 

    before do
      Devise::Mailer.deliveries.clear
      Timecop.freeze
      visit new_user_password_path
      fill_in 'Email', with: user.email
      click_button 'Send me reset password instructions'        
    end

    subject { user.reload }

    its(:reset_password_token) { should_not be_nil }
    its(:reset_password_sent_at) { should eq Time.now }
    specify { Devise::Mailer.deliveries.count.should eq 1 }
    specify { current_path.should eq new_user_session_path }
    specify { page.should have_selector('.alert-success', text: I18n.t('devise.passwords.send_instructions')) }
  end

  describe 'password reset page' do
    before do
      user.send_reset_password_instructions
      visit edit_user_password_path(reset_password_token: user.reset_password_token)
    end

    subject { page }

    it { should have_title('Reset Password') }
    it { should have_selector('h1', text: 'Change your password') }
    it { should have_selector('input#user_password') }
    it { should have_selector('input#user_password_confirmation') }
    it { should have_button('Change my password') }
  end

  describe 'response to password reset' do

    before do
      user.send_reset_password_instructions
      visit edit_user_password_path(reset_password_token: user.reset_password_token)
    end

    context 'failure' do 
      before { click_button 'Change my password' }

      specify { current_path.should eq user_password_path }
      specify { page.should have_selector('.alert-error', text: I18n.t('simple_form.error_notification.default_message')) }
      specify { expect { user_signed_in?.should be_false } }
    end

    context 'success' do

      before do 
        fill_in 'New password', with: 'newpassword'
        fill_in 'Confirm your new password', with: 'newpassword'
        click_button 'Change my password'
      end

      specify { current_path.should eq root_path }
      specify { page.should have_selector('.alert-success', text: I18n.t('devise.passwords.updated')) }
      specify { expect { user_signed_in?.should be_true } }
    end
  end

  describe 'new password email' do
    # TODO: Move this to a more appropriate spot, perhaps devise_email_spec.rb?

    before do
      Devise::Mailer.deliveries.clear
      user.send_reset_password_instructions
    end

    subject { Devise::Mailer.deliveries.last }

    its(:to) { should include(user.email) }
    its(:from) { should include('talisman@example.com') }
    its(:subject) { should include(I18n.t('devise.mailer.reset_password_instructions.subject')) }
    its(:body) { should have_link('Change my password') }
  end

end