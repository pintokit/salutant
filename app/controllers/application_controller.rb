class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception, except: :create

  def self.allow_cors(*actions)
    before_action :cors_filter, only: :actions

    # Rails recommends to use :null_session for APIs
    protect_from_forgery with: :null_session, only: :actions
  end

  private
    def cors_filter
      # Check that the `Origin` field matches our front-end client host
      if is_approved_domain?
        headers['Access-Control-Allow-Origin'] = request.headers['Origin']
      end
    end

    def is_approved_domain?
      request.headers['Origin'] == "http://davidsolis.me" || "http://davidmazza.com"
    end
end
