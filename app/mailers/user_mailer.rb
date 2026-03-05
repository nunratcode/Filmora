class UserMailer < ApplicationMailer
  default from: Rails.application.credentials.smtp[:user_name]

  # Письмо с новым паролем
  def password_reset
    @user = params[:user]
    @new_password = params[:password]  # передаём сгенерированный пароль

    mail(
      to: @user.email,
      subject: "Ваш новый пароль"
    )
  end
end
