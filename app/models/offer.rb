class Offer < ApplicationRecord

	has_and_belongs_to_many :advantages 
  has_many :user
	has_many :cache_user

end
