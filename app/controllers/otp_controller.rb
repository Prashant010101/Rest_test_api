class OtpController < ApplicationController
  def send_otp
    user = User.new(user_params)
    if user.save
      otp_code = generate_otp_code
      if save_otp(user, otp_code)
        UserMailer.with(user: user, otp_code: otp_code).send_otp(user, otp_code).deliver_now
        render json: { message: "OTP has been sent to your email. Please verify it.", otp: otp_code }, status: :ok
      else
        user.destroy
        render json: { error: 'Failed to save OTP' }, status: :unprocessable_entity
      end
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def resent_otp
    user = User.find_by(email: params[:email])
    if user
      otp_code = generate_otp_code
      if save_otp(user, otp_code)
        UserMailer.with(user: user, otp_code: otp_code).send_otp(user, otp_code).deliver_now
        render json: { message: "OTP has been resent to your email.", otp: otp_code }, status: :ok
      else
        render json: { error: 'Failed to save OTP' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end

  def generate_otp_code
    rand(1000..9999)
  end

  def save_otp(user, otp_code)
    user.otp_verifications.build(otp_code: otp_code).save
  end
end
