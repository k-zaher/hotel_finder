# User Model
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :trackable, :validatable, :token_authenticatable
  # Relations
  has_many :authentication_tokens
  has_many :bookings
end
