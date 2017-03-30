class SideUser < ApplicationRecord

	belongs_to :user
  belongs_to :cache_user
  has_many :dons

end
