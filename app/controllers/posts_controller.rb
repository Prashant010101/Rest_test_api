class PostsController < ApplicationController
  before_action :authorize_request, except: [:index, :show]

  def index
    @posts = Post.all
    render json: {post: @posts}
  end

  def show 
    @post = Post.find(params[:id])
    render json: {post: @post, like: @post.likes.count, comment: @post.comments}
  end

  def create
    #  debugger
    @post = @current_user.posts.build(post_params)
    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    render json: { message: 'Post deleted successfully' }, status: :ok
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
