require 'spec_helper'

describe 'Layouts' do
  
  subject { page }

  describe 'navbar' do 
    before { visit root_path }
    it { should have_selector('.brand', text: 'Talisman') }
    it { should have_link('Talisman', href: root_path) }

    describe 'for all users' do
      it { should have_link('Sign In', href: new_user_session_path) }
      it { should have_link('Sign Up', href: new_user_registration_path) }
    end

    describe 'for signed in users' do
      let(:user) { create(:user) }
      before { confirm_and_signin user }

      it { should_not have_link('Sign In', href: new_user_session_path) }
      it { should_not have_link('Sign Up', href: new_user_registration_path) }
      it { should have_link('Sign Out', href: destroy_user_session_path) }
    end
  end
end