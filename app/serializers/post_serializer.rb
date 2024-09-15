class PostSerializer  
  include FastJsonapi::ObjectSerializer
  attributes :id, :title, :content

  attributes :comments do |object|
    CommentSerializer.new(object.comments)
  end
  attributes :likes do |object|
    object.likes.count
  end
end
