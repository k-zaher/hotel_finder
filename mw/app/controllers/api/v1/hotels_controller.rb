# Hotels Controller which interfaces GooglePlaces::Fetcher module
class Api::V1::HotelsController < Api::BaseController
  before_action :verify_params, only: [:index]

  def index
    hotels = GooglePlaces::Fetcher.run(params[:lat], params[:long])
    render json: hotels, status: :ok
  rescue
    render json: { message: 'Service Not Available, please try again later' }, status: 503
  end

  private

  def verify_params
    render json: { message: 'Long and Lat are required' }, status: 401 if !params[:long] || !params[:lat]
  end
end
