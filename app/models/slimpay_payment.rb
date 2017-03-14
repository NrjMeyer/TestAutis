class SlimpayPayment < ApplicationRecord

  belongs_to :user
  belongs_to :cache_user

end