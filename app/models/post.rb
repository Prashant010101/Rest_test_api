class Post < ApplicationRecord
  belongs_to :user
  # belongs_to :category
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :title, presence: true, uniqueness: false
  validates :content, presence: true, uniqueness: false
end
