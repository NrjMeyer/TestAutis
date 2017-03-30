class SlimpayPayment < ApplicationRecord

  belongs_to :user
  belongs_to :cache_user
  has_many :dons

  def hash
    Digest::SHA1.hexdigest("s" + id.to_s)
  end

  def access_path
     "pdfs/" + hash + ".pdf"
  end

end
