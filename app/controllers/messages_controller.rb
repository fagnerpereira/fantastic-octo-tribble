class MessagesController < ApplicationController
  def create
    @message = current_user.messages.new(message_params)
    @message.chat = chat

    # binding.pry
    if @message.save
      redirect_to chat_path(chat), notice: "✅ Mensagem enviada com sucesso!"
    else
      flash.now[:alert] = "❌ Não foi possível enviar a mensagem. Verifique os erros abaixo."
      render "conversations/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.expect(message: [ :chat_id, :content ])
  end

  def chat
    @chat ||= Chat.find(params[:chat_id])
  end
end
