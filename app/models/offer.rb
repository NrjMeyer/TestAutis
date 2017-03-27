class Offer < ApplicationRecord

	has_and_belongs_to_many :advantages 
	belongs_to :user

end
