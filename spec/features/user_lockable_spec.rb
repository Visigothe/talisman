require 'spec_helper'

describe 'Lockable Module' do 

  let(:user) { create(:user) }

  describe 'attributes for user when user' do

    subject { user }

    context 'is unconfirmed' do
      its(:confirmed_at) { should be_nil }
      its(:active_for_authentication?) { should be_true }
      
      its(:valid_for_authentication?) { should be_true }
      its(:access_locked?) { should be_false }
      its(:failed_attempts) { should eq 0 }
    end

    context 'is confirmed' do

      before { user.confirm! }

      its(:confirmed_at) { should_not be_nil }
      its(:active_for_authentication?) { should be_true }

      its(:valid_for_authentication?) { should be_true }
      its(:access_locked?) { should be_false }
      its(:failed_attempts) { should eq 0 }
    end
  end

  describe 'failed_attempts' do

    before { user.confirm! }

    it 'increase with authentication failure' do 
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'something'
      click_button 'Sign in'
      user.reload.failed_attempts.should eq 1
    end

    describe 'exceeds the maximum allowed locks the account' do
      # Maximum allowed failed_attempts at this point is 20

      before do
        Devise::Mailer.deliveries.clear
        21.times do
          visit new_user_session_path
          fill_in 'user_email', with: user.email
          fill_in 'user_password', with: 'something'
          click_button 'Sign in'
        end
      end

      subject { user.reload }

      its(:failed_attempts) { should >= 21 }
      its(:access_locked?) { should be_true }
      specify { current_path.should eq new_user_session_path }
      specify { page.should have_selector('.alert-error', text: I18n.t('devise.failure.locked')) }
      specify { Devise::Mailer.deliveries.count.should eq 1 }
    end
  end

  describe 'does not allow a locked user to sign in' do

    before do
      user.confirm!
      22.times do
        visit new_user_session_path
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: 'something'
        click_button 'Sign in'
      end
    end

    specify { expect { user_signed_in?.should be_false } }
    specify { current_path.should eq new_user_session_path }
    specify { page.should have_selector('.alert-error', text: I18n.t('devise.failure.locked')) }
  end

  describe 'resend unlock instructions page' do

    before { visit new_user_unlock_path }

    subject { page }

    it { should have_selector('h2', text: 'Resend unlock instructions') }
    it { should have_selector('input#user_email') }
    it { should have_button('Resend unlock instructions') }
  end

  describe 'response to clicking the "Resend unlock instructions" button' do

    before do
      user.confirm!
      user.lock_access!
      Devise::Mailer.deliveries.clear
      visit new_user_unlock_path
      fill_in 'Email', with: user.email
      click_button 'Resend unlock instructions'
    end

    specify { Devise::Mailer.deliveries.count.should eq 1 }
    specify { current_path.should eq new_user_session_path }
    specify { page.should have_selector('.alert-success', I18n.t('devise.unlocks.send_instructions')) }
  end

  describe 'unlock failure with invalid token' do

    before do
      user.confirm!
      user.lock_access!
      visit user_unlock_path(unlock_token: 'invalid')
    end

    specify { user.reload.access_locked?.should be_true }
    specify { expect { user_signed_in?.should be_false } }
    specify { current_path.should eq user_unlock_path }
    # FIXME: expected to find css ".alert-error" but there were no matches
    # FIXME: 1 error prohibited this user from being saved: Unlock token is invalid => devise.not_saved.one devise.not_saved.other
    pending "specify { page.should have_selector('.alert-error', I18n.t('devise.failure.locked')) }"
  end

  describe 'unlock success' do 

    before do
      user.confirm!
      user.lock_access!
      visit user_unlock_path(unlock_token: user.unlock_token)
    end

    specify { user.reload.access_locked?.should be_false }
    specify { expect { user_signed_in?.should be_true } }
    specify { current_path.should eq new_user_session_path }
    specify { page.should have_selector('.alert-success', text: I18n.t('devise.unlocks.unlocked')) }
  end

  describe 'unlock email' do 
    # TODO: Move this to a more appropriate spot, perhaps devise_email_spec.rb?

    before do
      Devise::Mailer.deliveries.clear
      user.confirm!
      user.lock_access!
      user.send_unlock_instructions   
    end

    subject { Devise::Mailer.deliveries.last }

    its(:to) { should include(user.email) }
    its(:from) { should include('talisman@example.com') }
    its(:subject) { should include(I18n.t('devise.mailer.unlock_instructions.subject')) }
    its(:body) { should have_link('Unlock my account') }
  end
end
