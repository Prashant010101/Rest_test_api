class CommentsController < ApplicationController
  before_action :authorize_request

  def index 
    # byebug
    @post = Post.find(params[:post_id])
    @comments = @post.comments
    render json: @comments
  end

  def show
    # render json: @comment
    render json: {user_serializer: CommentSerializer.new(@comment)}
  end

  def create 
    # byebug
    # debugger
    @user = User.find(params[:comment][:user_id])
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    head :no_content
  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :content)
  end
end
