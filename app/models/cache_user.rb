class CacheUser < ApplicationRecord
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true
  validates :email, presence: true

  has_one :slimpay_payment
  has_one :paypal_payment
  has_many :side_users
  has_one :offer

end
