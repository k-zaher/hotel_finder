require 'rails_helper'

RSpec.describe Api::V1::HotelsController, type: :controller do
  let(:position) { { lat: '30.0444', long: '31.2357' } }
  let(:user) { FactoryGirl.create(:user) }

  before :each do
    request.headers['accept'] = 'application/json'
  end

  describe 'GET #index' do
    before :each do
      sign_in user
    end

    context 'Long or Lat is not provided' do
      it 'returns 401' do
        get :index
        expect(response).to have_http_status(401)
      end
    end

    context 'Long and Lat are valid' do
      before do
        stub_request(:any, /maps.googleapis.com/).to_return(body: File.new('spec/fixtures/hotels.json'))
      end

      it 'return a json array of parsed data' do
        get :index, params: position
        expect(JSON.parse(response.body).count).to eql(20)
      end
    end

    context 'Google Places Not Available' do
      before do
        Rails.cache.clear
        stub_request(:any, /maps.googleapis.com/).to_raise(StandardError)
      end
      it "return 'Service Not Available, please try again later' with 503 " do
        get :index, params: position
        expect(response).to have_http_status(503)
        expect(JSON.parse(response.body)['message']).to eql('Service Not Available, please try again later')
      end
    end
  end
end
