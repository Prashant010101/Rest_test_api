class UsersController < ApplicationController
  before_action :authorize_request, except: [:index, :show, :create]
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
      if @user.avatar.attached?
        render json: @user.as_json.merge(avatar_path: url_for(@user.avatar)), status: :ok
      else
        render json: @user, status: :ok
      end
    end 
  end 
  
  # debugger
  def create
    @user = User.new(user_params)
    if @user.save
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { user: @user, token: token, exp: time.strftime("%m-%d-%Y %H:%M"), username: @user.username}, status: :ok
    else
      render json: { errors: @user.errors.full_messages },status: :unprocessable_entity
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
      else
        render json: {error: 'Some Error occured while deleting :()'}, status: :not_found
      end
    end
  end

  private

  def user_params
    params.permit(:avatar, :name, :username, :email, :password, :password_confirmation)
  end
end
