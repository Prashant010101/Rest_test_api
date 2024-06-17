class BlackListedToken < ApplicationRecord
  validates :token, presence: true, uniqueness: true
end
