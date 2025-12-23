require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test "should save valid message" do
    message = Message.new(
      chat: chats(:chat_one),
      user: users(:worker_one),
      content: "Test message content"
    )
    assert message.save, "Failed to save valid message"
  end

  test "should belong to chat" do
    message = messages(:message_one)
    assert_equal chats(:chat_one), message.chat
  end

  test "should belong to user" do
    message = messages(:message_one)
    assert_equal users(:client_one), message.user
  end

  test "should have content" do
    message = messages(:message_one)
    assert_not_nil message.content
    assert message.content.length > 0
  end

  test "should be associated with correct chat" do
    message = messages(:message_two)
    assert_equal chats(:chat_one), message.chat
    assert_equal jobs(:in_progress_job), message.chat.job
  end

  test "should allow multiple messages in same chat" do
    chat = chats(:chat_one)
    message_count = chat.messages.count
    assert message_count >= 2, "Chat should have multiple messages"
  end
end
