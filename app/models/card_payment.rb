class CardPayment < ApplicationRecord

  belongs_to :user
  has_many :dons

  def hash
    Digest::SHA1.hexdigest("s" + id.to_s)
  end

  def access_path
     "pdfs/" + hash + ".pdf"
  end

  def reduction
    (amount.to_i * 0.34).round(2)
  end
end
