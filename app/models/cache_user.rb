class CacheUser < ApplicationRecord
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true
  validates :email, presence: true

  has_one :slimpay_payment

end
