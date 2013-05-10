class User < ActiveRecord::Base
  # Devise modules. Others available are: :token_authenticatable, :omniauthable
  devise :confirmable, :database_authenticatable, :lockable, :registerable,
         :recoverable, :rememberable, :timeoutable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me
end
