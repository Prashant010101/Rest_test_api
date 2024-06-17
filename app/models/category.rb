class Category < ApplicationRecord
  has_many :posts
  has_many :sub_categories
end
