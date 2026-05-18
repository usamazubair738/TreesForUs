require "application_system_test_case"

class FamilyMembershipsTest < ApplicationSystemTestCase
  setup do
    @family_membership = family_memberships(:one)
  end

  test "visiting the index" do
    visit family_memberships_url
    assert_selector "h1", text: "Family memberships"
  end

  test "should create family membership" do
    visit family_memberships_url
    click_on "New family membership"

    fill_in "Family", with: @family_membership.family_id
    fill_in "Membership type", with: @family_membership.membership_type
    fill_in "User", with: @family_membership.user_id
    click_on "Create Family membership"

    assert_text "Family membership was successfully created"
    click_on "Back"
  end

  test "should update Family membership" do
    visit family_membership_url(@family_membership)
    click_on "Edit this family membership", match: :first

    fill_in "Family", with: @family_membership.family_id
    fill_in "Membership type", with: @family_membership.membership_type
    fill_in "User", with: @family_membership.user_id
    click_on "Update Family membership"

    assert_text "Family membership was successfully updated"
    click_on "Back"
  end

  test "should destroy Family membership" do
    visit family_membership_url(@family_membership)
    click_on "Destroy this family membership", match: :first

    assert_text "Family membership was successfully destroyed"
  end
end
