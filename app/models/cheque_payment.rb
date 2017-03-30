class ChequePayment < ApplicationRecord

  belongs_to :user
  has_many :dons

end
