require 'spec_helper'

describe 'Rememberable' do
  
  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  before { visit new_user_session_path }

  describe 'remember me checkbox' do 
    it { should have_selector('.control-label', text: 'Remember me') }
    it { should have_selector('label.checkbox') }
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
      check('Remember me')
      confirm_and_signin user
    end
    it 'sets remember_created_at' do 
      expect { user.remember_created_at.should_not be_nil }
    end
    # Change test to reflect the desired length of time before doing so in config
    specify 'remember_created_at expires in 2 weeks' do
      expect { user.remember_expires_at.should == user.remember_created_at + 2.weeks }
    end
  end

  describe 'forget me' do 
    specify 'link' do
      pending # Fill in tests for links/buttons on specific pages before implementing
    end
    it 'removes remember_created_at' do
      user.forget_me!
      user.remember_created_at.should be_nil
    end
  end 
end
