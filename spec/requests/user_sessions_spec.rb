require 'spec_helper'

describe 'Sessions' do

  subject { page }

  let(:submit) { 'Sign in' }
  let(:user) { FactoryGirl.create(:user) }

  describe 'signin' do

    describe 'page' do 
      before { visit new_user_session_path }
      heading_and_title('Sign In', 'Sign In')
      it { should have_selector('input#user_email') }
      it { should have_selector('input#user_password') }
      it { should have_button(submit) }
    end

    context 'failure' do
      before { visit new_user_session_path }

      describe 'with no credentials' do
        before { click_button submit }
        # Re-renders the signin page with error message
        heading_and_title('Sign In', 'Sign In')
        it { should have_selector('.alert-error') }
        it { should have_content(I18n.t('devise.failure.invalid')) }
        it 'will not signin user' do
          expect { user_signed_in?.should be_false }
        end
      end
      
      describe 'by an unconfirmed user' do 
        let(:unconfirmed_user) { FactoryGirl.create(:user) }
        before { signin unconfirmed_user }
        # Re-renders the signin page with error message
        heading_and_title('Sign In', 'Sign In')
        it { should have_selector('.alert-error') }
        it { should have_content(I18n.t('devise.failure.unconfirmed')) }
        specify 'will not signin user' do
          expect { user_signed_in?.should be_false }
        end
      end

      describe 'with incorrect password' do 
        before do
          user.confirm!
          fill_in 'Email', with: user.email
          fill_in 'Password', with: 'mismatch'
          click_button submit
        end
        # Re-renders the signin page with error message
        heading_and_title('Sign In', 'Sign In')
        it { should have_selector('.alert-error') }
        it { should have_content(I18n.t('devise.failure.invalid')) }
        specify 'will not signin user' do
          expect { user_signed_in?.should be_false }
        end
      end
    end

    context 'success' do
      before { confirm_and_signin user }
      # Re-directs to root path with a success message
      heading_and_title('Talisman', '')
      it { should have_selector('.alert-success') }
      it { should have_content(I18n.t('devise.sessions.signed_in')) }
      specify 'will signin user' do
        expect { user_signed_in?.should be_true }
      end
    end
  end

  describe 'signout' do 
    before { confirm_and_signin user }
    it { should have_link('Sign Out') }

    describe 'success' do 
      before { click_link 'Sign Out' }
      # Re-directs to root path with success message
      heading_and_title('Talisman', '')
      it { should have_selector('.alert-success') }
      it { should have_content(I18n.t('devise.sessions.signed_out')) }
      specify 'will signout user' do
        expect { user_signed_in?.should be_false }
      end   
    end
  end
end
