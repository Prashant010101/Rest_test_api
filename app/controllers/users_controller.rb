class UsersController < ApplicationController
  before_action :authorize_request, except: [:index, :show, :send_otp, :verify_otp_and_create_user, :resent_user_otp]

  def index
    users = User.all
    data = users.map do |user|
      { username: user.username, avatar_url: user.avatar.present? ? url_for(user.avatar) : nil }
    end
    render json: data
  end

  def show
    user = User.find_by(id: params[:id])
    if user.nil?
      render json: { error: 'User not found' }, status: :not_found
    else
      if user.avatar.attached?
        render json: UserSerializer.new(user), status: :ok
      else
        render json: { user: user, msg: "There is no avatar" }, status: :ok
      end
    end
  end

  def send_otp
    user = User.new(user_params)
  
    if user.save
      otp_code = Random.new.rand(1000..9999)
      otp_save = user.otp_verifications.build(otp_code: otp_code)
      if otp_save.save
        UserMailer.with(user: user, otp_code: otp_code).send_otp(user, otp_code).deliver_now
        render json: { message: "OTP has been sent to your email. Please verify it.", otp: otp_code }, status: :ok
      else
        user.destroy
        render json: { error: otp_save.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def resent_user_otp
    user = User.find_by(email: params[:email])
    if user
      otp_code = Random.new.rand(1000..9999)
      otp_save = user.otp_verifications.build(otp_code: otp_code)
      if otp_save.save
        UserMailer.with(user: user, otp_code: otp_code).send_otp(user, otp_code).deliver_now
        render json: { message: "OTP has been sent to your email. Please verify it.", otp: otp_code}, status: :ok
      else
        render json: { error: otp_save.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def verify_otp_and_create_user
    user = User.find_by(email: params[:email])
    
    unless user
      render json: { error: "User not found. Please request OTP again." }, status: :not_found
      return
    end
  
    otp_verification = user.otp_verifications.find_by(otp_code: params[:otp])
    if otp_verification.nil?
      render json: { error: "Invalid OTP. Please enter the OTP sent to your email." }, status: :unprocessable_entity
    elsif Time.now > otp_verification.created_at + 180.seconds
      render json: { error: "OTP expired" }, status: :unprocessable_entity
    else
      user.activated = true
      if user.save
        UserMailer.with(user: user).welcome_email.deliver_now
        token = JsonWebToken.encode(user_id: user.id)
        time = Time.now + 24.hours
        render json: { user: user, token: token, exp: time.strftime("%m-%d-%Y %H:%M"), username: user.username }, status: :ok
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end  

  def update
    user = User.find_by(id: params[:id])
    if user.nil? || user.id != @current_user.id
      render json: { error: 'Unauthorized' }, status: :unauthorized
    else
      if user.update(user_params)
        UserMailer.with(user: user).update_user.deliver_now
        render json: user, status: :ok
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def destroy
    user = User.find_by(id: params[:id])
    if user.nil? || user.id != @current_user.id
      render json: { error: 'Unauthorized' }, status: :unauthorized
    else
      if user.destroy
        UserMailer.with(user: user).delete_user.deliver_now
        render json: { message: 'User deleted successfully.' }, status: :ok
      else
        render json: { error: 'Some error occurred while deleting :(' }, status: :unprocessable_entity
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:avatar, :name, :username, :email, :password, :password_confirmation, :status, :activated)
  end
end
