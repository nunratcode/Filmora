class PasswordsController < ApplicationController
  before_action :require_login

  def edit
  end

  def update
    @user = current_user

    # проверяем текущий пароль
    unless @user.authenticate(params[:current_password])
      flash.now[:alert] = "Неверный текущий пароль"
      return render :edit, status: :unprocessable_entity
    end

    # обновляем пароль
    if @user.update(
      password: params[:new_password],
      password_confirmation: params[:new_password_confirmation]
    )
      redirect_to user_path(@user), notice: "Пароль изменён"
    else
      flash.now[:alert] = @user.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def require_login
    redirect_to "/signin" unless current_user
  end
end
