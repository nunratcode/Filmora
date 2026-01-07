class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    target = User.find(params[:subscribed_to_id])
    current_user.subscriptions.find_or_create_by!(subscribed_to: target)
    redirect_back fallback_location: user_path(target)
  end

  def destroy
    sub = current_user.subscriptions.find(params[:id])
    sub.destroy
    redirect_back fallback_location: root_path
  end
end