require "test_helper"

class IdpUsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get idp_users_index_url
    assert_response :success
  end

  test "should get new" do
    get idp_users_new_url
    assert_response :success
  end
end
