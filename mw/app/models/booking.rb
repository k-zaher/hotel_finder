class Booking < ApplicationRecord

  enum preference: {king_bed: 0, single_bed: 1}
  # Validations
  validate :booking_dates_are_valid
  # Relations
  belongs_to :hotel
  belongs_to :user
  # Instance Methods

  def booking_dates_are_valid
    user_bookings = Booking.where(user_id: user_id)

    if user_bookings.where("checkin_date < ? and checkout_date > ?", checkout_date, checkin_date).first
      errors.add(:base, "Dates are already booked!")
    end
  end

end
