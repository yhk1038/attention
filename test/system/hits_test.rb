require "application_system_test_case"

class HitsTest < ApplicationSystemTestCase
  setup do
    @hit = hits(:one)
  end

  test "visiting the index" do
    visit hits_url
    assert_selector "h1", text: "Hits"
  end

  test "creating a Hit" do
    visit hits_url
    click_on "New Hit"

    fill_in "Ip address", with: @hit.ip_address
    fill_in "Notification", with: @hit.notification_id
    click_on "Create Hit"

    assert_text "Hit was successfully created"
    click_on "Back"
  end

  test "updating a Hit" do
    visit hits_url
    click_on "Edit", match: :first

    fill_in "Ip address", with: @hit.ip_address
    fill_in "Notification", with: @hit.notification_id
    click_on "Update Hit"

    assert_text "Hit was successfully updated"
    click_on "Back"
  end

  test "destroying a Hit" do
    visit hits_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Hit was successfully destroyed"
  end
end
