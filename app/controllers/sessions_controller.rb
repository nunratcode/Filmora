class SessionsController < ApplicationController
  def new
    render "home/signin"
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to "/user"
    else
      flash.now[:alert] = "Неправильный email или пароль"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to "/", notice: "Вы вышли из аккаунта"
  end
end
