class RegistrationController < ApplicationController
  def verify_otp_and_activate
    user = User.find_by(email: params[:email])
    return render json: { error: "User not found. Please request OTP again." }, status: :not_found unless user

    otp_verification = user.otp_verifications.find_by(otp_code: params[:otp])
    if otp_verification && otp_valid?(otp_verification)
      activate_user(user)
    else
      render json: { error: otp_verification.nil? ? "Invalid OTP" : "OTP expired" }, status: :unprocessable_entity
    end
  end

  private

  def otp_valid?(otp_verification)
    Time.now <= otp_verification.created_at + 180.seconds
  end

  def activate_user(user)
    user.update!(activated: true)
    UserMailer.with(user: user).welcome_email.deliver_now
    token = JsonWebToken.encode(user_id: user.id)
    time = Time.now + 24.hours
    render json: {
      user: user, token: token, exp: time.strftime("%m-%d-%Y %H:%M"), username: user.username
    }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end
end
