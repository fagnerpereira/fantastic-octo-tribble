require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new signup page" do
    get sign_up_path
    assert_response :success
    assert_select "h2", "Quem é você?"
  end

  test "should create user with valid data" do
    assert_difference("User.count", 1) do
      post sign_up_path, params: {
        user: {
          name: "New User",
          email: "newuser@example.com",
          password: "password123",
          password_confirmation: "password123",
          role: "worker"
        }
      }
    end
    assert_redirected_to root_path
    assert_match /Conta criada com sucesso/, flash[:notice]
    assert_not_nil session[:user_id]
  end

  test "should not create user without name" do
    assert_no_difference("User.count") do
      post sign_up_path, params: {
        user: {
          email: "newuser@example.com",
          password: "password123",
          password_confirmation: "password123",
          role: "worker"
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should not create user without email" do
    assert_no_difference("User.count") do
      post sign_up_path, params: {
        user: {
          name: "New User",
          password: "password123",
          password_confirmation: "password123",
          role: "worker"
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should not create user with duplicate email" do
    assert_no_difference("User.count") do
      post sign_up_path, params: {
        user: {
          name: "Another User",
          email: users(:worker_one).email,
          password: "password123",
          password_confirmation: "password123",
          role: "worker"
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should not create user with mismatched passwords" do
    assert_no_difference("User.count") do
      post sign_up_path, params: {
        user: {
          name: "New User",
          email: "newuser@example.com",
          password: "password123",
          password_confirmation: "different",
          role: "worker"
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should not create user without role" do
    assert_no_difference("User.count") do
      post sign_up_path, params: {
        user: {
          name: "New User",
          email: "newuser@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should create worker user" do
    assert_difference("User.count", 1) do
      post sign_up_path, params: {
        user: {
          name: "Worker User",
          email: "worker@example.com",
          password: "password123",
          password_confirmation: "password123",
          role: "worker"
        }
      }
    end
    user = User.find_by(email: "worker@example.com")
    assert_not_nil user, "User was not created"
    assert_equal "worker", user.role, "User role should be worker"
    assert user.worker?, "User should respond to worker? as true"
  end

  test "should create client user" do
    assert_difference("User.count", 1) do
      post sign_up_path, params: {
        user: {
          name: "Client User",
          email: "client@example.com",
          password: "password123",
          password_confirmation: "password123",
          role: "client"
        }
      }
    end
    user = User.find_by(email: "client@example.com")
    assert_not_nil user, "User was not created"
    assert_equal "client", user.role, "User role should be client"
    assert user.client?, "User should respond to client? as true"
  end

  test "should set session after successful signup" do
    post sign_up_path, params: {
      user: {
        name: "Session Test",
        email: "session@example.com",
        password: "password123",
        password_confirmation: "password123",
        role: "worker"
      }
    }
    user = User.find_by(email: "session@example.com")
    assert_equal user.id, session[:user_id]
  end
end
