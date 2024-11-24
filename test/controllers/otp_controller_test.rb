require "test_helper"

class OtpControllerTest < ActionDispatch::IntegrationTest
  test "should get send_otp" do
    get otp_send_otp_url
    assert_response :success
  end

  test "should get resent_otp" do
    get otp_resent_otp_url
    assert_response :success
  end
end
