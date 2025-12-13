class ApplicationController < ActionController::Base
  before_action :authenticate_user
  before_action :set_current_user

  private

  def set_current_user
    Current.user = current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def user_logged_in?
    current_user.present?
  end
  helper_method :user_logged_in?

  def authenticate_user
    redirect_to login_path, alert: "You must be logged in to access this page." unless user_logged_in?
  end
end
