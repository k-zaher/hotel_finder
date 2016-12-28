# Booking Model
class Booking < ApplicationRecord
  enum preference: { king_bed: 0, single_bed: 1 }
  # Validations
  validate :booking_dates_are_valid
  validates :guest_name, :preference, :checkin_date, :checkout_date, :user_id, :hotel_id, presence: true
  # Relations
  belongs_to :hotel
  belongs_to :user

  delegate :name, to: :hotel, prefix: true
  delegate :pid, to: :hotel, prefix: true
  # Instance Methods

  def booking_dates_are_valid
    errors.add(:base, 'Dates are already booked!') if overlapped_bookings
    errors.add(:checkout_date, 'Should be after checkin date') if checkout_greater_than_checkin
  end

  def overlapped_bookings
    Booking.find_by('user_id = ? and checkin_date < ? and checkout_date > ?', user_id, checkout_date, checkin_date)
  end

  def checkout_greater_than_checkin
    checkin_date > checkout_date
  end
end
