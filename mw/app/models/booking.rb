# Booking Model
class Booking < ApplicationRecord
  enum preference: { king_bed: 0, single_bed: 1 }

  # Validations
  validate :booking_dates_are_valid
  validates :guest_name, :preference, :checkin_date, :checkout_date, :user_id, :hotel_id, presence: true

  # Relations
  belongs_to :hotel
  belongs_to :user

  # Delegates hotel_name and hotel_pid to hotel model
  delegate :name, to: :hotel, prefix: true
  delegate :pid, to: :hotel, prefix: true

  private

  def booking_dates_are_valid
    errors.add(:checkout_date, 'Should be after checkin date') if checkin_greater_than_checkout
    errors.add(:base, 'Dates are already booked!') if overlapped_bookings
  end

  def overlapped_bookings
    Booking.find_by('user_id = ? and checkin_date < ? and checkout_date > ?', user_id, checkout_date, checkin_date)
  end

  def checkin_greater_than_checkout
    checkin_date > checkout_date
  end
end
