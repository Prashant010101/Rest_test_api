class FollowsController < ApplicationController
  before_action :authorize_request

  def show
    @user = find_user
    if @user.status == 'private' 

      render json: {follower: @user.followers, following: @user.followings, total_follower: @user.followers.count, total_following: @user.followings.count}
    elsif @user.status == 'private' && @user.followers.exists?(@current_user.id)
      render json: {}
    else
      render json: {follower: @user.followers, following: @user.followings, total_follower: @user.followers.count, total_following: @user.followings.count}
    end
    
  end

  def create 
    # byebug
    @user = find_user
    @follow = Follow.create(follower_id: @current_user.id, followed_id: @user.id)
    # if followed_id
    # byebug
    if @follow.save
      render json: {follow: @follow, success: true, message: "You are now following #{@user.username}"}, status: :created
    else
      render json: { success: false, errors: @follow.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @user = find_user
    @follow = Follow.find_by(follower_id: @current_user.id, followed_id: @user.id)
    if @follow.destroy
      render json: {success: true, message: "You are no longer following #{@user.username}"}, status: :successfully
    else
      render json: {success: false, message: "Some error occurred while unfollowing."}, status: :unprocessable_entity
    end
  end

  private 

  def find_user
    User.find(params[:id])
  end
end
