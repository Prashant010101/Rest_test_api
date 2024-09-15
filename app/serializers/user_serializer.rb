class UserSerializer 
  include FastJsonapi::ObjectSerializer

  attributes :id, :name, :email, :status

  attribute :avatar_url do |object, params|
    object.avatar_url
  end
  

  # has_many :posts
  attributes :posts  do |object|
    PostSerializer.new(object.posts)
  end
end
