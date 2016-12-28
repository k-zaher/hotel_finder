# Booking Controller which handles create and the Public API
class Api::V1::BookingsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :find_or_create_hotel, only: [:create]

  def index
    render json: Booking.includes(:hotel, :user)
  end

  def for_user
    render json: Booking.where(user_id: params[:user_id]).includes(:hotel)
  end

  def create
    booking = @hotel.bookings.build(booking_params)
    booking.user_id = current_user.id
    if booking.save
      render json: { booking: booking }, status: :ok
    else
      render json: { message: booking.errors.full_messages }, status: 422
    end
  end

  private

  def find_or_create_hotel
    @hotel = Hotel.find_or_create_by(pid: hotel_params[:id]) { |obj| obj.name = hotel_params[:name] }
  end

  def booking_params
    params.require(:booking).permit(:guest_name, :preference, :checkin_date, :checkout_date)
  end

  def hotel_params
    params.require(:hotel).permit(:name, :id)
  end
end
