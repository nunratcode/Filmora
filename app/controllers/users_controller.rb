class UsersController < ApplicationController
  # показываем форму регистрации
  def new
    @user = User.new
    render "home/registration"
  end

  # создаем пользователя после отправки формы
  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to "/user", notice: "Регистрация прошла успешно!"
    else
      render "home/registration", status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :password)
  end
end
