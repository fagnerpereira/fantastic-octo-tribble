require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should save valid user" do
    user = User.new(
      name: "Test User",
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123",
      role: :worker
    )
    assert user.save, "Failed to save valid user"
  end

  test "should not save user without name" do
    user = User.new(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123",
      role: :worker
    )
    assert_not user.save, "Saved user without name"
    assert_includes user.errors[:name], "é obrigatório"
  end

  test "should not save user without email" do
    user = User.new(
      name: "Test User",
      password: "password123",
      password_confirmation: "password123",
      role: :worker
    )
    assert_not user.save, "Saved user without email"
    assert_includes user.errors[:email], "é obrigatório"
  end

  test "should not save user without role" do
    user = User.new(
      name: "Test User",
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    assert_not user.save, "Saved user without role"
    assert_includes user.errors[:role], "é obrigatório"
  end

  test "should not save user with duplicate email" do
    User.create!(
      name: "User One",
      email: "duplicate@example.com",
      password: "password123",
      password_confirmation: "password123",
      role: :worker
    )
    user2 = User.new(
      name: "User Two",
      email: "duplicate@example.com",
      password: "password123",
      password_confirmation: "password123",
      role: :client
    )
    assert_not user2.save, "Saved user with duplicate email"
    assert_includes user2.errors[:email], "já está em uso"
  end

  test "should not save user with mismatched password confirmation" do
    user = User.new(
      name: "Test User",
      email: "test@example.com",
      password: "password123",
      password_confirmation: "different",
      role: :worker
    )
    assert_not user.save, "Saved user with mismatched password"
    assert user.errors[:password_confirmation].any?, "No password confirmation error"
  end

  test "should authenticate with correct password" do
    user = users(:worker_one)
    assert user.authenticate("password123"), "Failed to authenticate with correct password"
  end

  test "should not authenticate with incorrect password" do
    user = users(:worker_one)
    assert_not user.authenticate("wrongpassword"), "Authenticated with wrong password"
  end

  test "worker should have posted_jobs association" do
    client = users(:client_one)
    assert_respond_to client, :posted_jobs
  end

  test "worker should have accepted_jobs association" do
    worker = users(:worker_one)
    assert_respond_to worker, :accepted_jobs
  end

  test "should have messages association" do
    user = users(:worker_one)
    assert_respond_to user, :messages
  end

  test "should have chats association" do
    user = users(:worker_one)
    assert_respond_to user, :chats
  end

  test "should be client role" do
    user = users(:client_one)
    assert user.client?, "User should be client"
    assert_not user.worker?, "User should not be worker"
  end

  test "should be worker role" do
    user = users(:worker_one)
    assert user.worker?, "User should be worker"
    assert_not user.client?, "User should not be client"
  end
end
