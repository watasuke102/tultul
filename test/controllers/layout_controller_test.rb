require "test_helper"

class LayoutControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get layout_show_url
    assert_response :success
  end
end
