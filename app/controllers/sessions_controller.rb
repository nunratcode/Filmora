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
    session.delete(:user_id)
    redirect_to root_path
  end
end
