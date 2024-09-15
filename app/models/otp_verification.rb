class OtpVerification < ApplicationRecord
  belongs_to :user
  validates :otp_code, presence: true, numericality: { only_integer: true }
  # validates :email, presence: true, uniqueness: true
  # validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
