class TokenGeneratorsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  # POST /request_jwt
  def create
    auth_header = request.headers['Authorization'].split(' ').last
    if auth_header == ENV.fetch("JWT_AUTHENTICATION")
      response.status = 200
      response.body = "JWT Token is here"
      render json: ""
    else
      response.status = 401
      render json: ""
    end
  end
end
