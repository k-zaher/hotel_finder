# Interfaces Client Token
class AuthenticationToken < ApplicationRecord
  belongs_to :user
end
