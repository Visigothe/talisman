require 'spec_helper'

describe "Trackable" do 

  let(:user) { FactoryGirl.create(:user) }

  before { user.confirm! }

  describe "logging in" do 

    before do 
      visit new_user_session_path
      signin user
    end

    it "increases sign_in_count " do
      pending "Revisit at a later point in time"
      user.sign_in_count.should == 1
    end

    it "sets current_sign_in_at" do
      pending "Revisit at a later point in time"
      user.current_sign_in_at.should_not be_nil
    end

    it "sets current_sign_in_ip" do
      pending "Revisit at a later point in time"
      user.current_sign_in_ip.should_not be_nil
    end

    it "does not set last_sign_in_at" do
      pending "Revisit at a later point in time"
      user.last_sign_in_at.should be_nil
    end

    it "does not set last_sign_in_ip" do
      pending "Revisit at a later point in time"
      user.last_sign_in_ip.should be_nil  
    end

    describe "after logging out and then logging in" do

      before do 
        click_link "Sign Out"
        visit new_user_session_path
        signin user
      end

      it "increases sign_in_count" do
        pending "Revisit at a later point in time"
        user.sign_in_count.should == 2
      end

      it "sets current_sign_in_at" do
        pending "Revisit at a later point in time"
        user.current_sign_in_at.should_not be_nil
      end

      it "sets current_sign_in_ip" do
        pending "Revisit at a later point in time"
        user.current_sign_in_ip.should_not be_nil
      end

      it "sets last_sign_in_at" do
        pending "Revisit at a later point in time"
        user.last_sign_in_at.should_not be_nil
      end

      it "sets last_sign_in_ip" do
        pending "Revisit at a later point in time"
        user.last_sign_in_ip.should_not be_nil 
      end
    end
  end
end