class User < ApplicationRecord
  #Follower and following association
  has_many :follows

  has_many :follower_relationships, foreign_key: :followed_id, class_name: 'Follow'
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :following_relationships, foreign_key: :follower_id, class_name: 'Follow'
  has_many :followings, through: :following_relationships, source: :followed
  #others
  has_secure_password
  has_many :likes
  has_many :otp_verifications
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  # mount_uploader :avatar, AvatarUploader
  has_one_attached :avatar
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true

  VALID_STATUSES = ['public', 'private']

  validates :status, inclusion: {in: VALID_STATUSES}

  def avatar_url
    Rails.application.routes.url_helpers.url_for(avatar) if avatar.attached?
  end
end
