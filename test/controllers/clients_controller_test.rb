require "test_helper"

class ClientsControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard as client" do
    log_in_as(users(:client_one))
    get dashboard_path
    assert_response :success
  end

  test "should not get dashboard when not logged in" do
    get dashboard_path
    assert_redirected_to login_path
  end
end
