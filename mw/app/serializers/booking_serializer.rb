# Booking Serializer
class BookingSerializer < ActiveModel::Serializer
  attributes :id, :guest_name, :hotel_name, :hotel_pid, :preference, :checkin_date, :checkout_date

  belongs_to :user
end
