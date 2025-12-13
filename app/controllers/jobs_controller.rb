class JobsController < ApplicationController
  before_action :ensure_client, only: [:new, :create]
  before_action :ensure_worker, only: [:index, :show]

  def index
    @jobs = Job.where(status: :open).order(created_at: :desc)
  end

  def new
    @job = Job.new
  end

  def create
    @job = current_user.posted_jobs.new(job_params)
    if @job.save
      redirect_to dashboard_path, notice: "Serviço publicado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @job = Job.find(params[:id])
  end

  private

  def job_params
    params.require(:job).permit(:title, :description, :price)
  end

  def ensure_client
    redirect_to root_path, alert: "Acesso não autorizado." unless current_user.client?
  end

  def ensure_worker
    redirect_to root_path, alert: "Acesso não autorizado." unless current_user.worker?
  end
end
