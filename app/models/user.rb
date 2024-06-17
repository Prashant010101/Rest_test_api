class User < ApplicationRecord
  has_secure_password
  has_many :likes
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  # mount_uploader :avatar, AvatarUploader
  has_one_attached :avatar
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
end
