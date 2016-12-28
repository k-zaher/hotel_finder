class Api::BaseController < ApplicationController
  before_action :check_format
  before_action :authenticate_user!
  respond_to :json

  def check_format
    puts request.format
    render :head => true, :status => 406 unless request.format == 'application/json'
  end

end