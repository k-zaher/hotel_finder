# User Serializer
class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email
end
