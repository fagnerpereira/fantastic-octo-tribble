class JobsController < ApplicationController
  before_action :set_job, only: [ :show, :edit, :update, :destroy ]
  before_action :ensure_client, only: [ :new, :create, :edit, :update, :destroy ]
  before_action :ensure_worker, only: [ :index ]
  before_action :ensure_job_owner, only: [ :edit, :update, :destroy ]

  def index
    @jobs = Job.all.order(created_at: :desc)
  end

  def new
    @job = Job.new
  end

  def create
    @job = current_user.posted_jobs.new(job_params)
    if @job.save
      redirect_to dashboard_path, notice: "✅ Serviço publicado com sucesso! Aguardando profissionais."
    else
      flash.now[:alert] = "❌ Não foi possível publicar o serviço. Verifique os erros abaixo."
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @job = Job.find(params[:id])
  end

  def edit
    # @job set by before_action
  end

  def update
    if @job.update(job_params)
      redirect_to dashboard_path, notice: "✅ Serviço atualizado com sucesso!"
    else
      flash.now[:alert] = "❌ Não foi possível atualizar o serviço. Verifique os erros abaixo."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @job.worker.present?
      redirect_to dashboard_path, alert: "⚠️ Não é possível excluir um serviço com profissional designado."
      return
    end

    @job.destroy
    redirect_to dashboard_path, notice: "🗑️ Serviço excluído com sucesso."
  end

  private

  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(:title, :description, :price)
  end

  def ensure_client
    unless current_user.client?
      redirect_to root_path, alert: "⛔ Acesso não autorizado. Apenas clientes podem gerenciar serviços."
    end
  end

  def ensure_worker
    unless current_user.worker?
      redirect_to root_path, alert: "⛔ Acesso não autorizado. Apenas profissionais podem ver o mural."
    end
  end

  def ensure_job_owner
    unless @job.client == current_user
      redirect_to dashboard_path, alert: "⛔ Você só pode editar seus próprios serviços."
    end
  end
end
