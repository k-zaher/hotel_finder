class Api::V1::BookingsController < ApplicationController
  before_action :authenticate_user! , only:[:create]

  def index
  end

  def create
    hotel = Hotel.find_or_create_by(pid: hotel_params[:id]) do |hotel|
      hotel.name = hotel_params[:name]
    end
    booking = hotel.bookings.build(booking_params)
    booking.user_id = current_user.id
    if booking.save
      render json: {booking: booking}, status: :ok
    else
      render json: {message: "Failed to save Booking"}, status: 301
    end
  end



  private


  def booking_params
    params.require(:booking).permit(:guest_name,:preference,:checkin_date,:checkout_date)
  end

  def hotel_params
    params.require(:hotel).permit(:name,:id)
  end
end
