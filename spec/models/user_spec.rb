require 'spec_helper'

describe User do

  let(:user) { build(:user) }

  subject { user }

  it { should be_valid }

  describe 'rails attributes' do
    %w[id created_at updated_at].each do |attribute|
      it { should have_db_column(attribute.to_sym) }
      it { should_not allow_mass_assignment_of(attribute.to_sym) }
    end
  end

  # Devise :database_authenticable
  describe 'authentication attributes' do
    it { should have_db_column(:email) }
    it { should have_db_column(:encrypted_password) }
    %w[email password password_confirmation].each do |attribute|
      it { should allow_mass_assignment_of attribute.to_sym}
    end
    it { should_not allow_mass_assignment_of(:encrypted_password) }
  end

  # Devise :validatable (custom email regex)
  describe 'validations for' do 
    
    context 'email' do 
      let(:invalid_emails) { %w[user@example,com user_at_example.com user.example@com. user@an_example.com user@an+example.com] }
      let(:valid_emails) { %w[user@example.COM a-us_er@exam.ple.com a.user@example.com a+user@example.com] }
      
      it { should validate_presence_of(:email) }
      it { should_not ensure_inclusion_of(:email).in_array(invalid_emails) }
      it { should ensure_inclusion_of(:email).in_array(valid_emails) }
      it { should validate_uniqueness_of(:email).case_insensitive }
    end

    context 'password and confirmation' do
      
      it { should validate_presence_of(:password) }
      it { should ensure_length_of(:password).is_at_least(8) }
      it { should ensure_length_of(:password).is_at_most(128) }
      it { should validate_confirmation_of(:password) }
    end
  end

  # Devise :confirmable
  describe 'confirmation attributes' do
    %w[confirmation_sent_at confirmation_token confirmed_at unconfirmed_email].each do |attribute|
      it { should have_db_column(attribute.to_sym) }
      it { should_not allow_mass_assignment_of(attribute.to_sym) }
    end
  end

  # Devise :rememberable
  describe 'remember me attribute' do
    it { should have_db_column(:remember_created_at) }
    it { should_not allow_mass_assignment_of(:remember_created_at) }
    it { should allow_mass_assignment_of(:remember_me) }
  end

  # Devise :recoverable
  describe 'password reset attributes' do
    %w[reset_password_token reset_password_sent_at].each do |attribute|
      it { should have_db_column(attribute.to_sym) }
      it { should_not allow_mass_assignment_of(attribute.to_sym) }
    end
  end

  # Devise trackable
  describe 'trackable attributes' do
    %w[sign_in_count current_sign_in_at current_sign_in_ip last_sign_in_at last_sign_in_ip].each do |attribute|
      it { should have_db_column(attribute.to_sym) }
      it { should_not allow_mass_assignment_of(attribute.to_sym) }
    end
  end

  # Devise :lockable
  describe 'lockable attributes' do 
    %w[failed_attempts unlock_token locked_at].each do |attribute|
      it { should have_db_column(attribute.to_sym) }
      it { should_not allow_mass_assignment_of(attribute.to_sym) }
    end
  end
end