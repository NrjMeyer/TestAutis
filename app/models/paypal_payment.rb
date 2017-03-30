class PaypalPayment < ApplicationRecord

  belongs_to :user
  has_many :dons

  def hash
    Digest::SHA1.hexdigest("p" + id.to_s)
  end

  def access_path
     "pdfs/" + hash + ".pdf"
  end

end
