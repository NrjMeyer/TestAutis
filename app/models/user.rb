class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  has_one :offer
  has_one :role
  has_many :paypal_payments
  has_many :slimpay_payments
  has_many :side_users
  has_many :payment_cheques
 
end
