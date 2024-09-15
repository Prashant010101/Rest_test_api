class LikeMailer < ApplicationMailer
  def like_created(like)
    @like = like 
    @user = @like.user.username
    @post = @like.post.title
    mail (
      from: "prashant0jangir@gmail.com",
      to: @like.post.user.email,
      subject: "Someone liked your post!"
    )
  end
end
