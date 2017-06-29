class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: :create

  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception
end
