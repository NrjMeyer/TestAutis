class Offer < ApplicationRecord

	has_many :advantages 
	belongs_to :user

end
