class CardPayment < ApplicationRecord

  belongs_to :user
  has_many :dons

  def reduction
    (amount.to_i * 0.34).round(2)
  end
end
