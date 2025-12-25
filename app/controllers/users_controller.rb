class UsersController < ApplicationController
  skip_before_action :authenticate_user, only: [ :new, :create ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "✅ Conta criada com sucesso! Bem-vindo à Rocha, #{@user.name}!"
    else
      flash.now[:alert] = "❌ Não foi possível criar a conta. Verifique os erros abaixo."
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    redirect_to root_path, alert: "Acesso não autorizado." unless @user == current_user
  end

  def update
    @user = User.find(params[:id])
    if @user == current_user && @user.update(user_update_params)
      redirect_to user_path(@user), notice: "✅ Perfil atualizado com sucesso!"
    else
      flash.now[:alert] = "❌ Não foi possível atualizar o perfil. Verifique os erros abaixo."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # TODO: implement a better role assignment strategy
  # for example a user could be both client and worker
  def user_params
    params.expect(user: [ :name, :email, :phone, :password, :password_confirmation, :role ])
  end

  def user_update_params
    params.expect(user: [ :name, :email, :phone, :password, :password_confirmation ])
  end
end
