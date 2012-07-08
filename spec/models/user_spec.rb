# == Schema Information
#
# Table name: users
#
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  created_at             :datetime         not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  failed_attempts        :integer          default(0)
#  id                     :integer          not null, primary key
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0)
#  unconfirmed_email      :string(255)
#  unlock_token           :string(255)
#  updated_at             :datetime         not null
#

require 'spec_helper'

describe User do

  before(:all) { @user = FactoryGirl.build(:user) }

  subject { @user }

  # Devise :database_authenticable
  it "responds to these attributes" do 
    should respond_to(:email)
    should respond_to(:password)
    should respond_to(:password_confirmation)
  end

  it { should be_valid }

  # Devise :validatable (custom email regex)
  describe "validates" do 
    
    context "email" do 
      
      it "cannot be blank" do 
        @user.email = ""
        should_not be_valid
      end

      it "cannot have an invalid format" do 
        email_addresses = %w[user@example,com user_at_example.com user.example@com.
                       user@an_example.com chef@an+example.com]
        email_addresses.each do |invalid_email_address|
          @user.email = invalid_email_address
          should_not be_valid
        end
      end

      it "has a valid format" do 
        email_addresses = %w[user@example.COM a-us_er@exam.ple.com a.user@example.com 
                         a+user@example.com]
        email_addresses.each do |valid_email_address|
          @user.email = valid_email_address
          should be_valid
        end
      end

      it "is unique" do 
        user_with_same_email = @user.dup
        user_with_same_email.email.upcase
        user_with_same_email.save
        should_not be_valid
      end
    end

    context "password" do
      
      it "cannot be blank" do 
        @user.password = ""
        should_not be_valid
      end

      it "cannot be too short" do 
        @user.password = "a" * 5
        should_not be_valid
      end

      it "cannot be too long" do 
        @user.password = "a" * 130
        should_not be_valid
      end
    end

    context "password confirmation" do
      
      it "cannot be blank" do 
        @user.password_confirmation = ""
        should_not be_valid
      end

      it "cannot be different from the password" do 
        @user.password_confirmation = "mismatch"
        should_not be_valid
      end

      it "matches the password" do
        @user.password = @user.password_confirmation = "matching"
        should be_valid
      end
    end
  end

  # Devise :rememberable
  describe "remember me" do 
    
    before { @user.remember_me! }

    it { should respond_to(:remember_created_at) }
  end

  # Devise :recoverable
  describe "password reset" do 

    before { @user.send_reset_password_instructions }
    
    it { should respond_to(:reset_password_token) }
    it { should respond_to(:reset_password_sent_at) }
  end

  # Devise trackable
  describe "trackable" do 

    before do
      @user.confirm!
    end

    it { should respond_to(:sign_in_count) }
    it { should respond_to(:current_sign_in_at) }
    it { should respond_to(:current_sign_in_ip) }
    it { should respond_to(:last_sign_in_at) }
    it { should respond_to(:last_sign_in_ip) }
  end

  # Devise :lockable
  describe "lockable" do 
    
    before { @user.lock_access! }

    it { should respond_to(:failed_attempts) }
    it { should respond_to(:unlock_token) }
    it { should respond_to(:locked_at) }
  end
end