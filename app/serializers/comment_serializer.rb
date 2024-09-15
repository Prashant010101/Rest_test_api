class CommentSerializer 
  include FastJsonapi::ObjectSerializer
  attributes :id, :user_id, :content
end
