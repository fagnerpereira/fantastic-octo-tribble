class ChatsController < ApplicationController
  def show
    @chat = Chat.find(params[:id])
    @job = @chat.job
    # Ensure current user is part of the chat
    unless [ @job.client_id, @job.worker_id ].include?(current_user.id)
      redirect_to root_path, alert: "You are not authorized to view this chat."
      return
    end
    @messages = @chat.messages.order(:created_at)
    @message = @chat.messages.new
  end
end
