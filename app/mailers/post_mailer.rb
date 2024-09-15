class PostMailer < ApplicationMailer
  def post_created(post, user)
    @post = post
    @user = user
    mail (
      from: "prashant0jangir@gmail.com",
      to: @user.email, 
      subject: "New Post Created")
  end

  def post_updated(post,user)
    @post = post
    @user = user
    mail (
      from: "prashant0jangir@gmail.com",
      to: @user.email,
      subject: "Post Updated")
  end

  def post_deleted(post, user)
    @post = post
    @user = user
    mail (
      from: "prashant0jangir@gmail.com",
      to: @user.email,
      subject: "Post Deleted")
  end
end
