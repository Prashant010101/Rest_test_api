class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  def login
    @user = User.find_by_email(params[:email])
    if @user &.authenticate(params[:password]) && @user.activated == true
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      UserMailer.login_mailer(@user).deliver_now
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"), username: @user.username }, status: :ok
    else
      render json: {error: 'you are unauthorized or You are not activated' }, status: :unauthorized
    end
  end

  def omniauth
    @user = User.find_or_create_by(uid: request.env['omniauth.auth']['uid'], provider: request.env['omniauth.auth']['provider']) do |u|
        u.username = request.env['omniauth.auth']['info']['name']
        u.email = request.env['omniauth.auth']['info']['email']
        u.password = SecureRandom.hex(10)
    end
    if @user.valid?
        session[:user_id] = @user.id
        redirect_to root_path
    else
        render :new
    end
  end

  private
  
  def login_params
    params.permit(:email, :password)
  end
end
