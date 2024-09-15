class UsersController < ApplicationController
  before_action :authorize_request, except: [:index, :show, :create, :verify_otp]
  # before_action :find_user, except: %i[create index show]

  def index
    # debugger
    @users = User.all
    data = []
    @users.each do |user|
      # data << user
      data << user.username
      data << url_for(user.avatar) if user.avatar.present? 
    end
    render json: data
  end
  
  def show
    @user = User.find(params[:id])
    if @user.nil? 
      render json: { error: 'User not found'}, status: :not_found
    else 
      # byebug
      if @user.avatar.attached?
        # render json: @user
        # render json: @user.as_json.merge(avatar_path: url_for(@user.avatar)), status: :ok
        render json: {user_serializer: UserSerializer.new(@user)}
      else
        render json: {user: @user, msg: :"there is no avatar"}, status: :ok
      end
    end 
  end 
  def verify_otp
    # byebug
    email =  params[:email]
    otp_code_in_method = params[:otp]
    @user = User.find_by(email: email)  #kind of an Extra Variable
    @otp_obj = OtpVerification.find_by(user_id: @user.id)
    @otp = OtpVerification.find_by(otp_code: otp_code_in_method, email: email)
    # byebug
    if @otp_obj.otp_code != otp_code_in_method.to_i
      render json: {message: "OTP verification successful"}
      true
      if Time.now > @otp_obj.created_at + 180.seconds # && @otp_obj.otp_code != otp_code_in_method.to_i   #Commented after "And" coz it is not neccessary rn
        render json: { error: "otp expire"}
      else
        @user.activated = true
        @user.save
        render json: { user_serializere: UserSerializer.new(@user), resule: "you can login"}
      end
    else
      render json: {error: "Wrong OTP, Doesn't match."}
      false
    end
  end

  # debugger
  def create
    # byebug
    @user = User.new(user_params)

    random = Random.new
    # UserMailer.with(email: params[:email])

    @user.otp_verifications.build(otp_code: random.rand(999..9990) + random.rand(1..9)).save
    @otp = OtpVerification.find_by(user_id: @user.id).otp_code
    if verify_otp
      if @user.save
        # byebug
        UserMailer.with(user: @user).welcome_email.deliver_now
        # if @otp
          token = JsonWebToken.encode(user_id: @user.id)
          time = Time.now + 24.hours.to_i
          render json: { user: @user, token: token, exp: time.strftime("%m-%d-%Y %H:%M"), username: @user.username}, status: :ok
      else
        render json: { errors: @user.errors.full_messages },status: :unprocessable_entity
      end
    else
      render json: {error: "OTP verification failed!"}
    end
  end

  def update
    # debugger
    @user = User.find(params[:id])
    u_id = params[:id]
    u_id = u_id.to_i  
    if u_id != @current_user.id
      render json: {error: 'Unauthorized'}, status: :unauthorized
    else
      if @user.update(user_params)
        render json: @user
        UserMailer.with(user: @user).update_user.deliver_now
      else
        render json: { errors: @user.errors.full_messages}, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    u_id = params[:id]
    u_id = u_id.to_i  
    if u_id.id != @current_user.id
      render json: {error: 'Unauthorized'}, status: :unauthorized
    else
      if @user.destroy
        render json: {message: 'User deleted successfully.' }, status: :ok
        UserMailer.with(user: @user).delete_user.deliver_now
      else
        render json: {error: 'Some Error occured while deleting :('}, status: :not_found
      end
    end
  end

  private

  def otp_params
    params.permit(:otp_code, :email)
  end

  def user_params
    params.permit(:avatar, :name, :username, :email, :password, :password_confirmation, :status)
  end
end
