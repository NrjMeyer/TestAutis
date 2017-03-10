class CacheUser < ApplicationRecord
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true
  validates :email, presence: true
end
