require 'test_helper'

class OrganizationUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization_user = organization_users(:one)
  end

  test "should get index" do
    get organization_users_url
    assert_response :success
  end

  test "should get new" do
    get new_organization_user_url
    assert_response :success
  end

  test "should create organization_user" do
    assert_difference('OrganizationUser.count') do
      post organization_users_url, params: { organization_user: { organization_id: @organization_user.organization_id, user_id: @organization_user.user_id } }
    end

    assert_redirected_to organization_user_url(OrganizationUser.last)
  end

  test "should show organization_user" do
    get organization_user_url(@organization_user)
    assert_response :success
  end

  test "should get edit" do
    get edit_organization_user_url(@organization_user)
    assert_response :success
  end

  test "should update organization_user" do
    patch organization_user_url(@organization_user), params: { organization_user: { organization_id: @organization_user.organization_id, user_id: @organization_user.user_id } }
    assert_redirected_to organization_user_url(@organization_user)
  end

  test "should destroy organization_user" do
    assert_difference('OrganizationUser.count', -1) do
      delete organization_user_url(@organization_user)
    end

    assert_redirected_to organization_users_url
  end
end
