class LikesController < ApplicationController
  before_action :authorize_request
  before_action :find_post

  def create
    # debugger
    if already_liked?
      render json: {error: "You can't like more than once"}, status: :unprocessable_entity
    else
      @like = Like.create(user_id: @current_user.id, post_id: @post.id)
      LikeMailer.like_created(@like).deliver_now
      render json: @like
    end
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end

  def already_liked?
    # debugger
    Like.where(user_id: @current_user.id, post_id: @post.id).exists?
  end

  # def find_like
  #   @like = @post.likes.find(params[:id])
  # end
end
