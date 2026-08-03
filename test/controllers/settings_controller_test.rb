require "test_helper"

class SettingsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }

  test "edit shows the settings page" do
    get edit_settings_path
    assert_response :success
  end

  test "profile updates the email address" do
    patch profile_settings_path, params: { user: { email_address: "new@example.com" } }
    assert_redirected_to edit_settings_path
    assert_equal "new@example.com", users(:one).reload.email_address
  end

  test "profile rejects a duplicate email address" do
    patch profile_settings_path, params: { user: { email_address: users(:two).email_address } }
    assert_response :unprocessable_entity
  end

  test "password changes the password when the current password is correct" do
    patch password_settings_path, params: { user: { current_password: "password", password: "new-password", password_confirmation: "new-password" } }
    assert_redirected_to edit_settings_path
    assert users(:one).reload.authenticate("new-password")
  end

  test "password is rejected when the current password is wrong" do
    patch password_settings_path, params: { user: { current_password: "wrong", password: "new-password", password_confirmation: "new-password" } }
    assert_response :unprocessable_entity
    assert users(:one).reload.authenticate("password")
  end

  test "password is rejected when confirmation does not match" do
    patch password_settings_path, params: { user: { current_password: "password", password: "new-password", password_confirmation: "different" } }
    assert_response :unprocessable_entity
    assert users(:one).reload.authenticate("password")
  end

  test "preferences updates the time zone" do
    patch preferences_settings_path, params: { user: { time_zone: "Copenhagen" } }
    assert_redirected_to edit_settings_path
    assert_equal "Copenhagen", users(:one).reload.time_zone
  end

  test "preferences rejects an invalid time zone" do
    patch preferences_settings_path, params: { user: { time_zone: "Not A Zone" } }
    assert_response :unprocessable_entity
  end
end
