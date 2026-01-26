class ApplicationController < ActionController::Base
  before_action :authenticate_user
  before_action :set_current_user

  private

  def set_current_user
    Current.user = current_user
  end

  def current_user
    if Rails.env.development?
      # DEV MODE: Auto-login as first user if not logged in
      @current_user ||= User.find_by(id: session[:user_id]) || User.first
    elsif session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
  helper_method :current_user

  def user_logged_in?
    current_user.present?
  end
  helper_method :user_logged_in?

  def authenticate_user
    return if Rails.env.development?
    redirect_to login_path, alert: "You must be logged in to access this page." unless user_logged_in?
  end
end
