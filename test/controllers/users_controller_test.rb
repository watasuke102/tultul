require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post users_url, params: { user: {
         email_address: "usercontrollertest@example.com",
         password: "a", password_confirmation: "a"
      } }
    end
    assert_redirected_to new_session_url
  end
end
