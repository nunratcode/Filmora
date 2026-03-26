class HomeController < ApplicationController
  def willbesoon
  end

  def about
  end

  def subscription
  @subscription = Subscription.new
  end

  def subscription
    @subscription = Subscription.new
  end

  def create_subscription
    email = params[:subscription][:email]
    @subscription = Subscription.new(
      subscription_type: params[:subscription][:subscription_type],
      for_whom: params[:subscription][:for_whom],
      duration: params[:subscription][:duration]
    )

    if @subscription.valid?
      SubscriptionMailer.confirmation(email, @subscription).deliver_now
      redirect_to subscription_path, notice: "Подписка оформлена!"
    else
      render :subscription, status: :unprocessable_entity
    end
  end
end
