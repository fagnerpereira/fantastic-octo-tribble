require "test_helper"

class ChatTest < ActiveSupport::TestCase
  test "should save valid chat" do
    job = jobs(:open_job)
    chat = Chat.new(job: job)
    assert chat.save, "Failed to save valid chat"
  end

  test "should belong to job" do
    chat = chats(:chat_one)
    assert_equal jobs(:in_progress_job), chat.job
  end

  test "should have messages association" do
    chat = chats(:chat_one)
    assert_respond_to chat, :messages
    assert chat.messages.count > 0, "Chat should have messages"
  end

  test "should have users through messages" do
    chat = chats(:chat_one)
    assert_respond_to chat, :users
  end

  test "chat messages should be retrievable" do
    chat = chats(:chat_one)
    messages = chat.messages
    assert_includes messages, messages(:message_one)
    assert_includes messages, messages(:message_two)
  end

  test "should get users who participated in chat" do
    chat = chats(:chat_one)
    users = chat.users
    assert_includes users, users(:client_one)
    assert_includes users, users(:worker_one)
  end
end
