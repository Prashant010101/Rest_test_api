require "test_helper"

class RegistrationControllerTest < ActionDispatch::IntegrationTest
  test "should get verify_otp_and_activate" do
    get registration_verify_otp_and_activate_url
    assert_response :success
  end
end
