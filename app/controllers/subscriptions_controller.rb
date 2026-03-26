class SubscriptionsController < ApplicationController
  def create
    email = params[:subscription][:email]
    subscription_type = params[:subscription][:subscription_type]
    for_whom = params[:subscription][:for_whom]
    duration = params[:subscription][:duration]

    subscription = OpenStruct.new(
      subscription_type: subscription_type,
      for_whom: for_whom,
      duration: duration
    )

    SubscriptionMailer.confirmation(email, subscription).deliver_now

    redirect_to "/subscription", notice: "Подписка оформлена! Проверьте почту."
  end
end
