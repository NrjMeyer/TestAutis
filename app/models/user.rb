class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  belongs_to :offer
  belongs_to :role
  has_many :paypal_payments
  has_many :slimpay_payments
  has_many :side_users
  has_many :cheque_payments
  has_many :card_payments
  has_many :dons

  def side_user_number
    side_users.count
  end

end
