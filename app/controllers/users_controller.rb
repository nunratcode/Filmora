class UsersController < ApplicationController
  before_action :require_login, only: [ :show, :edit, :update ]

  # Профиль пользователя
  def show
    @user = current_user
  end

  # Форма регистрации
  def new
    @user = User.new
    render "home/registration"
  end

  # Создание нового пользователя
  def create
    @user = User.new(user_params_create)

    if @user.save
      session[:user_id] = @user.id
      redirect_to "/user"
    else
      render "home/registration", status: :unprocessable_entity
    end
  end

  # Форма редактирования профиля
  def edit
    @user = current_user
  end

  # Сохранение изменений профиля
  def update
    @user = current_user

    if params[:user][:avatar].present?
      @user.avatar.attach(params[:user][:avatar])
    end

    if @user.update(user_params_update)
      redirect_to "/user", notice: "Профиль обновлён"
    else
      Rails.logger.debug @user.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # Проверка авторизации
  def require_login
    redirect_to "/signin" unless current_user
  end

  # Параметры для регистрации
  def user_params_create
    params.require(:user).permit(:email, :username, :password)
  end

  # Параметры для редактирования профиля
  def user_params_update
    params.require(:user).permit(:username) # email и пароль не меняем
  end
end
