class UsersController < ApplicationController
  before_action :authorize_request, except: [:index, :show]

  def index
    users = User.all
    data = users.map do |user|
      { username: user.username, avatar_url: user.avatar.present? ? url_for(user.avatar) : nil }
    end
    render json: data
  end

  def show
    user = User.find_by(id: params[:id])
    if user
      render json: user_with_avatar_response(user), status: :ok
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def update
    user = User.find_by(id: params[:id])
    if user&.id == @current_user.id
      if user.update(user_params)
        UserMailer.with(user: user).update_user.deliver_now
        render json: user, status: :ok
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def destroy
    user = User.find_by(id: params[:id])
    if user&.id == @current_user.id
      if user.destroy
        UserMailer.with(user: user).delete_user.deliver_now
        render json: { message: 'User deleted successfully.' }, status: :ok
      else
        render json: { error: 'Some error occurred while deleting :(' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:avatar, :name, :username, :email, :password, :password_confirmation, :status, :activated)
  end

  def user_with_avatar_response(user)
    if user.avatar.attached?
      UserSerializer.new(user)
    else
      { user: user, msg: "There is no avatar" }
    end
  end
end
