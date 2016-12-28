FactoryGirl.define do
  factory :booking do
    guest_name 'Kareem Diaa'
    preference 'king_bed'
    association :hotel, factory: :hotel
    association :user, factory: :user

    trait :valid do
      checkin_date { 2.days.from_now }
      checkout_date { 4.days.from_now }
    end

    trait :in_valid do
      checkin_date { 2.days.from_now }
      checkout_date { 4.days.ago }
    end

    trait :dates_booked_already do
      checkin_date { 3.days.from_now }
      checkout_date { 4.days.from_now }
    end
  end
end
