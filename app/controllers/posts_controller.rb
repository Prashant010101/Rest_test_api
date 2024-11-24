class PostsController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  count = 0

  def index
    @posts = Post.all
    render json: {post: @posts}
  end

  def show 
    @post = Post.find(params[:id])
    count += 1
    # render json: {post: @post, like: @post.likes.count, comment: @post.comments}
    # render json: {user_serializer: PostSerializer.new(@post), like: @post.likes.count, comment: @post.comments }
    render json: {post_serializer: PostSerializer.new(@post), count: count}
  end

  def create
    #  debugger
    @post = @current_user.posts.build(post_params)
    @user = User.find(@post.user_id)
    if @post.save
      PostMailer.post_created(@post, @user).deliver_now
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end 
  
  def update
    @post = Post.find(params[:id])
    @user = User.find(@post.user_id)
    if @post.update(post_params)
      PostMailer.post_updated(@post, @user).deliver_now
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @post.Post.find(params[:id])
    @user = User.find(@post.user_id)
    @post.destroy
    PostMailer.post_deleted(@post, @user).deliver_now
    render json: { message: 'Post deleted successfully' }, status: :ok
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
