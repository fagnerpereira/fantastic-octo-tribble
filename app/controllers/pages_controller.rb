class PagesController < ApplicationController
  skip_before_action :authenticate_user, only: [:home]

  def home
    if user_logged_in?
      if current_user.client?
        redirect_to dashboard_path
      elsif current_user.worker?
        redirect_to mural_path
      end
    else
      # Renders app/views/pages/home.html.erb
    end
  end
end
