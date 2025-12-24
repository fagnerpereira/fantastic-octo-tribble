class ClientsController < ApplicationController
  before_action :ensure_client

  def dashboard
    @jobs = current_user.posted_jobs
  end

  private

  def ensure_client
    redirect_to root_path, alert: "Acesso não autorizado." unless current_user.client?
  end
end
