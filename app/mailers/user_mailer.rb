class UserMailer < ApplicationMailer
  
  # byebug
  def welcome_email
    @user = params[:user]
    @otp = OtpVerification.find_by(user_id: @user.id).otp_code
    mail(
      from: "prashant0jangir@gmail.com",
      to: @user.email, 
      subject: "You're welcome.")
  end

  def update_user
    @user = params[:user]
    mail(
      from: "prashant0jangir@gmail.com",
      to: @user.email,
      subject: "Your account has been updated.")
  end

  def delete_user
    @user = params[:user]
    mail(
      from: "prashant0jangir@gmail.com",
      to: @user.email,
      subject: "Your account has been deleted.")
  end

  def login_mailer(user)
    @user = user
    mail(
      from: "prashant0jangir@gmail.com",
      to: @user.email,
      subject: "Thank you for login.")
  end
  
  # def send_otp(user, otp)
  #   @user = params[:user]
  #   @otp = params[:otp]
  #   mail(
  #     from: "prashant0jangir@gmail.com",
  #     to: @user.email,
  #     subject: "#{@user.username}Your OTP is #{@otp} for verification"
  #     )
  # end
end
