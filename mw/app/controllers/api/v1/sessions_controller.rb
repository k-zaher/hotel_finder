class Api::V1::SessionsController < Devise::SessionsController
  def create
    user = warden.authenticate!(auth_options)
    token = Tiddle.create_and_return_token(user, request)
    render json: { authentication_token: token }
  end

  def destroy
    Tiddle.expire_token(current_user, request) if current_user
    render json: {}
  end

  def failure
    render :status => 401,
           :json => { :success => false,
                      :message => 'Login Failed'}
  end

  private

  def auth_options
    { scope: resource_name, recall: "#{controller_path}#failure" }
  end

  # this is invoked before destroy and we have to override it
  def verify_signed_out_user
  end
end
