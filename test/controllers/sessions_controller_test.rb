require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get login page" do
    get login_path
    assert_response :success
  end

  test "should login with valid credentials" do
    post login_path, params: {
      email: users(:worker_one).email,
      password: "password123"
    }
    assert_redirected_to root_path
    assert_match(/Bem-vindo de volta/, flash[:notice])
    assert_equal users(:worker_one).id, session[:user_id]
  end

  test "should not login with invalid email" do
    post login_path, params: {
      email: "invalid@example.com",
      password: "password123"
    }
    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end

  test "should not login with invalid password" do
    post login_path, params: {
      email: users(:worker_one).email,
      password: "wrongpassword"
    }
    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end

  test "should not login without email" do
    post login_path, params: {
      password: "password123"
    }
    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end

  test "should not login without password" do
    post login_path, params: {
      email: users(:worker_one).email
    }
    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end

  test "should logout" do
    # First login
    post login_path, params: {
      email: users(:worker_one).email,
      password: "password123"
    }
    assert_not_nil session[:user_id]

    # Then logout
    delete logout_path
    assert_redirected_to root_path
    assert_match(/saiu da sua conta/, flash[:notice])
    assert_nil session[:user_id]
  end

  test "should logout when not logged in" do
    delete logout_path
    assert_redirected_to root_path
    assert_nil session[:user_id]
  end
end
