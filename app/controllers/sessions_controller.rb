class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: [ :new, :create, :destroy ]

  def new
    # Renders app/views/sessions/new.html.erb
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "👋 Bem-vindo de volta, #{user.name}!"
    else
      flash.now[:alert] = "❌ Email ou senha incorretos. Tente novamente."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "👋 Você saiu da sua conta. Até logo!"
  end
end
