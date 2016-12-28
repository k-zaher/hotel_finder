# User Model
class User < ApplicationRecord
  devise :database_authenticatable, :trackable, :validatable, :token_authenticatable

  validates :name, presence: true
  validates :email, presence: true,
                    format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ },
                    uniqueness: { case_sensitive: false }

  # Relations
  has_many :authentication_tokens
  has_many :bookings
end
