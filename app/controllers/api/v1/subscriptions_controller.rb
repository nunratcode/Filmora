class Api::V1::SubscriptionsController < ApplicationController
  protect_from_forgery with: :null_session

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      render json: {
        status: "success",
        user: {
          id: user.id,
          email: user.email,
          subscription: {
            subscription_type: user.subscription&.subscription_type,
            duration: user.subscription&.duration,
            for_whom: user.subscription&.for_whom
          }
        }
      }
    else
      render json: { status: "error", message: "Неверный email или пароль" }, status: :unauthorized
    end
  end
end
