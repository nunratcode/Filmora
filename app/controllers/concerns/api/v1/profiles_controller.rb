module Api
  class ProfilesController < ApplicationController
    protect_from_forgery with: :null_session

    before_action :set_profile

    # PATCH /api/profiles/:id
    def update
      if @profile.update(profile_params)
        render json: {
          status: "updated",
          profile: {
            id: @profile.id,
            first_name: @profile.first_name,
            last_name: @profile.last_name,
            bio: @profile.bio
          }
        }
      else
        render json: {
          status: "error",
          errors: @profile.errors.full_messages
        }, status: :unprocessable_entity
      end
    end

    private

    def set_profile
      @profile = Profile.find(params[:id])
    end

    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :bio)
    end
  end
end
