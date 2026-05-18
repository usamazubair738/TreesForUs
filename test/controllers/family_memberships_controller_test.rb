require "test_helper"

class FamilyMembershipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @family_membership = family_memberships(:one)
  end

  test "should get index" do
    get family_memberships_url
    assert_response :success
  end

  test "should get new" do
    get new_family_membership_url
    assert_response :success
  end

  test "should create family_membership" do
    assert_difference("FamilyMembership.count") do
      post family_memberships_url, params: { family_membership: { family_id: @family_membership.family_id, membership_type: @family_membership.membership_type, user_id: @family_membership.user_id } }
    end

    assert_redirected_to family_membership_url(FamilyMembership.last)
  end

  test "should show family_membership" do
    get family_membership_url(@family_membership)
    assert_response :success
  end

  test "should get edit" do
    get edit_family_membership_url(@family_membership)
    assert_response :success
  end

  test "should update family_membership" do
    patch family_membership_url(@family_membership), params: { family_membership: { family_id: @family_membership.family_id, membership_type: @family_membership.membership_type, user_id: @family_membership.user_id } }
    assert_redirected_to family_membership_url(@family_membership)
  end

  test "should destroy family_membership" do
    assert_difference("FamilyMembership.count", -1) do
      delete family_membership_url(@family_membership)
    end

    assert_redirected_to family_memberships_url
  end
end
