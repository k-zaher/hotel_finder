FactoryGirl.define do
  factory :user do
    name 'Kareem Diaa'
    sequence(:email) { |n| "test#{n}@test.com" }
    password 'test@1234'
    password_confirmation 'test@1234'
  end
end
