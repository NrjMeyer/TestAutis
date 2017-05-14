class CardPayment < ApplicationRecord

  belongs_to :user
  has_many :dons

end
