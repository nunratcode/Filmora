class UsersController < ApplicationController
  # Показываем форму регистрации
  def new
    @user = User.new
    render "home/registration"
  end

  # Создаем пользователя после отправки формы
  def create
    @user = User.new(user_params)

    if @user.save
      # автоматически логиним после регистрации
      session[:user_id] = @user.id
      redirect_to "/user", notice: "Регистрация прошла успешно!"
    else
      render "home/registration", status: :unprocessable_entity
    end
  end

  private

  # Разрешаем только нужные параметры
  def user_params
    params.require(:user).permit(:email, :username, :password)
  end
end
