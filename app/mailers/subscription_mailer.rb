class SubscriptionMailer < ApplicationMailer
  default from: Rails.application.credentials.smtp[:user_name]  # или ваш email

  # Метод для письма с подтверждением подписки
  def confirmation(email, subscription)
    @subscription = subscription
    mail(
      to: email,            # вот здесь правильно mail, а не email
      subject: "Ваша подписка оформлена"
    )
  end
end
