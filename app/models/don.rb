class Don < ApplicationRecord

  belongs_to :user
  belongs_to :cache_user
  belongs_to :slimpay_payment
  belongs_to :paypal_payment
  belongs_to :cheque_payment
  belongs_to :card_payment

end
