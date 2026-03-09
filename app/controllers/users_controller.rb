class UsersController < ApplicationController
  before_action :require_login, only: [ :show ]

  def show
    @user = current_user
  end

  def new
    @user = User.new
    render "home/registration"
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to "/user"
    else
      render "home/registration", status: :unprocessable_entity
    end
  end

  private

  def require_login
    redirect_to "/signin" unless current_user
  end

  def user_params
    params.require(:user).permit(:email, :username, :password)
  end
end
