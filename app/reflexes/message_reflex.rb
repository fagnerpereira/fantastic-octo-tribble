class MessageReflex < ApplicationReflex
  def create
    chat = Chat.find(element.dataset[:chat_id])
    message = chat.messages.new(message_params.merge(user: current_user))

    if message.save
      cable_ready[chat].insert_adjacent_html(
        selector: "#messages",
        position: "beforeend",
        html: ApplicationController.render(Messages::MessageComponent.new(message: message))
      )
      cable_ready[chat].reset_form(selector: "#new-message-form")
      cable_ready.broadcast
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
