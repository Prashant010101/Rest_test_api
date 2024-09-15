class LikeSerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer
  attributes :id
end
