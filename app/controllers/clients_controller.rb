class ClientsController < ApplicationController
  def show
    @user = current_user
    @jobs = @user.posted_jobs.order(created_at: :desc)
  end
end
