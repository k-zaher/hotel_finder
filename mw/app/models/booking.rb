class Booking < ApplicationRecord

  belongs_to :hotel
  belongs_to :user

  enum preference: {king_bed: 0, single_bed: 1}
end
