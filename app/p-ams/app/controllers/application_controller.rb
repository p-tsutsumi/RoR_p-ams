class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  helper_method :current_user, :logged_in?

  private
    def authenticate_user!
      unless logged_in?
        redirect_to "/login"
      end
    end

    def logged_in?
      session[:user_id].present?
    end

    def current_user
      @current_user ||= session[:user_name] if logged_in?
    end
end
