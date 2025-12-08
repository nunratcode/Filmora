class ProfilesController < ApplicationController
  before_action :set_profile, only: [ :show, :edit, :update, :content, :favorites ]
  before_action :authenticate_user!, only: [ :edit, :update ]

  def index
    @profiles = Profile.all.page(params[:page])
  end

  def show
  end

  def content
    @posts = @profile.user.posts.page(params[:page])
  end

  def favorites
    @favorites = @profile.user.favorites.page(params[:page])
  end

  def edit
    unless @profile.user == current_user
      redirect_to @profile, alert: "Нет прав"
    end
  end

  def update
    unless @profile.user == current_user
      redirect_to @profile, alert: "Нет прав" and return
    end

    if @profile.update(profile_params)
      redirect_to @profile, notice: "Профиль обновлён"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  end

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :bio, :profile_photo)
  end
end
