class PasswordResetsController < ApplicationController
  # GET /password_resets/new
  def new
    render "home/password_resets"
  end

  # POST /password_resets
  def create
    user = User.find_by(email: params[:email])

    if user
      # Генерация нового пароля
      new_password = SecureRandom.urlsafe_base64(10)
      user.password = new_password
      user.save!

      # Отправка письма
      UserMailer.with(user: user, password: new_password).password_reset.deliver_now

      render json: { message: "Мы отправили новый пароль на указанную почту" }, status: :ok
    else
      render json: { message: "Пользователь с таким email не найден" }, status: :unprocessable_entity
    end
  end
end
