require 'rails_helper'

RSpec.describe Api::V1::BookingsController, type: :controller do
  let!(:users) { Array.new(3) { FactoryGirl.create(:user) } }
  before :each do
    request.headers['accept'] = 'application/json'
  end

  describe 'GET #index' do
    let!(:booking) { FactoryGirl.create(:booking, :valid) }

    it 'returns an array of Bookings' do
      get :index
      expect(response).to have_http_status(200)
      expect(response.body).to eql([booking].map { |obj| BookingSerializer.new(obj) }.to_json)
    end
  end

  describe 'GET #for_user' do
    let!(:booking) { FactoryGirl.create(:booking, :valid) }

    context 'User has bookings' do
      it 'returns an array of Bookings for a given user' do
        get :for_user, params: { user_id: users.first.id }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eql(users.first.bookings.count)
        expect(response.body).to eql(users.first.bookings.map { |obj| BookingSerializer.new(obj) }.to_json)
      end
    end

    context 'User has no bookings' do
      it 'returns an an empty array' do
        get :for_user, params: { user_id: users.second.id }
        expect(response).to have_http_status(200)
        expect(response.body).to eql('[]')
      end
    end
  end

  describe 'POST #create' do
    let!(:booking) { FactoryGirl.attributes_for(:booking, :valid) }
    let!(:booking_with_booked_dates) { FactoryGirl.attributes_for(:booking, :dates_booked_already) }
    let!(:booking_invalid) { FactoryGirl.attributes_for(:booking, :in_valid) }
    let!(:hotel) { FactoryGirl.attributes_for(:hotel) }

    before { sign_in User.first }

    context 'Booking valid' do
      it 'returns the booking with status 200' do
        post :create, params: { booking: booking, hotel: hotel }
        expect(response).to have_http_status(200)
        expect(assigns(:booking)).to be_a(Booking)
        expect(assigns(:hotel)).to be_a(Hotel)
      end
    end

    context 'Dates Booked Before' do
      before do
        post :create, params: { booking: booking, hotel: hotel }
      end
      it "returns 'Dates are already booked' with status 422" do
        post :create, params: { booking: booking_with_booked_dates, hotel: hotel }
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['message'].first).to eql('Dates are already booked!')
      end
    end

    context 'Checkin Date greater than Checkout Date' do
      it "returns 'Checkout Date Should be after checkin date' with status 422" do
        post :create, params: { booking: booking_invalid, hotel: hotel }
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['message'].first).to eql('Checkout date Should be after checkin date')
      end
    end
  end
end
