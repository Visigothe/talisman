require 'spec_helper'

describe 'Rememberable Module' do
  
  let(:user) { create(:user) }
  
  subject { page }

  before { visit new_user_session_path }

  describe 'remember me checkbox on signin page' do 

    it { should have_selector('input#user_remember_me') }
    it 'is not checked' do
      remember_me = find('input#user_remember_me')
      remember_me.should_not be_checked     
    end
    it 'can be checked' do 
      check('Remember me')
      remember_me = find('input#user_remember_me')
      remember_me.should be_checked
    end
  end

  describe 'after login' do

    before do
      Timecop.freeze
      check('user_remember_me')
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'Sign in'
    end

    subject { user.reload }

    its(:remember_created_at) { should eq Time.now }
    its(:remember_expires_at) { should eq subject.remember_created_at + 2.weeks }
  end
end
