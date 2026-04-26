require "test_helper"

class UserProfilesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_profiles_index_url
    assert_response :success
  end

  test "should get show" do
    get user_profiles_show_url
    assert_response :success
  end

  test "should get new" do
    get user_profiles_new_url
    assert_response :success
  end

  test "should get edit" do
    get user_profiles_edit_url
    assert_response :success
  end
end
