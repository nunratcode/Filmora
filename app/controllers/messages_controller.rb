class MessagesController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource

  def index
    @inbox = Message.where(recipient: current_user).order(created_at: :desc).page(params[:page])
  end

  def sent
    @sent = Message.where(sender: current_user).order(created_at: :desc).page(params[:page])
  end

  def show
    @message = Message.find(params[:id])
  end

  def create
    recipient = User.find(params[:recipient_id])
    @message = current_user.sent_messages.build(message_params.merge(recipient: recipient))
    if @message.save
      redirect_to messages_path, notice: "Сообщение отправлено"
    else
      redirect_back fallback_location: root_path, alert: "Ошибка при отправке"
    end
  end

  def destroy
    m = Message.find(params[:id])
    if m.sender == current_user || m.recipient == current_user || current_user.admin?
      m.destroy
      redirect_back fallback_location: messages_path, notice: "Удалено"
    else
      redirect_back fallback_location: messages_path, alert: "Нет прав"
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :subject)
  end
end
