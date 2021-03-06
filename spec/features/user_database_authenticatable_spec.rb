require 'spec_helper'

describe 'Database Authenticatable Module' do

  let(:submit) { 'Sign in' }

  subject { page }

  describe 'sign in page' do

    before do
      visit root_path
      click_link 'Sign In'
    end

    it { should have_title('Sign In') }
    it { should have_selector('h1', text: 'Sign In') }
    it { should have_selector('input#user_email') }
    it { should have_selector('input#user_password') }
    it { should have_button(submit) }
  end

  describe 'response to sign in failure' do
    
    context 'by an unconfirmed user' do

      let(:unconfirmed_user) { create(:user) }

      before { signin unconfirmed_user }

      its(:current_path) { should eq new_user_session_path }
      specify { expect { user_signed_in?.should be_false } }
      it { should have_selector('.alert-error', text: I18n.t('devise.failure.unconfirmed')) }
    end

    context 'with invalid email' do

      let(:user) { create(:user) }
      
      before do
        user.confirm!
        visit new_user_session_path
        fill_in 'user_email', with: 'invalid_email'
        fill_in 'user_password', with: user.password
        click_button submit
      end

      its(:current_path) { should eq new_user_session_path }
      specify { expect { user_signed_in?.should be_false } }
      it { should have_selector('.alert-error', text: I18n.t('devise.failure.invalid')) }
    end

    context 'with invalid password' do

      let(:user) { create(:user) }

      before do
        user.confirm!
        visit new_user_session_path
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: 'mismatch'
        click_button submit
      end

      its(:current_path) { should eq new_user_session_path }
      specify { expect { user_signed_in?.should be_false } }
      it { should have_selector('.alert-error', text: I18n.t('devise.failure.invalid')) }
    end
  end

  describe 'response to sign in success' do

    let(:user) { create(:user) }

    before do
      user.confirm!
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button submit
    end

    its(:current_path) { should eq root_path }
    specify { expect { user_signed_in?.should be_true } }
    it { should have_selector('.alert-success', text: I18n.t('devise.sessions.signed_in')) }
  end

  describe 'response to signout' do

    let(:user) { create(:user) }

    before do
      user.confirm!
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button submit
      click_link 'Sign Out'
    end

    its(:current_path) { should eq root_path }
    specify { expect { user_signed_in?.should be_false } }
    it { should have_selector('.alert-success', text: I18n.t('devise.sessions.signed_out')) }
  end
end
