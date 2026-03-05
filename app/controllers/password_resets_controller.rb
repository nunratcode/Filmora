class PasswordResetsController < ApplicationController
  def new
    render "home/password_resets"
  end

  def create
    user = User.find_by(email: params[:email])

    if user
      new_password = SecureRandom.urlsafe_base64(10)
      user.password = new_password
      user.save!
      UserMailer.with(user: user, password: new_password).password_reset.deliver_now
      message = "Мы отправили новый пароль на указанную почту"
    else
      message = "Пользователь с таким email не найден"
    end

    render json: { message: message }
  end
end
