# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')

1.times do
	o = Offer.create!(amount: 40, mensualisable: false)
	o2 = Offer.create!(amount: 60, mensualisable: true)
	o3 = Offer.create!(amount: 120, mensualisable: true)
	1.times do
		a1 = Advantage.new(description: "Accès à l’espace adhérent")
		a1.offers << o
		a1.offers << o2
		a1.offers << o3
		a1.save
		a2 = Advantage.new(description: "Carte de membre")
		a2.offers << o2
		a2.offers << o3
		a2.save
		a3 = Advantage.new(description: "Accès aux documents privilégiés")
		a3.offers << o2
		a3.offers << o3
		a3.save
		a4 = Advantage.new(description: "Espace questions/réponses")
		a4.offers << o2
		a4.offers << o3
		a4.save
		a5 = Advantage.new(description: "Devenez membre actif")
		a5.offers << o3
		a5.save
	end
end

Role.create!(name: 'Particulier')
Role.create!(name: 'Parent d’enfant atteint d’autisme')
Role.create!(name: 'Personne atteinte d’autisme')
Role.create!(name: 'Professionnel de l’autisme')

OfferDon.create!(amount: 15, story: "Vous financez une journée de travail d’un spécialiste")
OfferDon.create!(amount: 30, story: "Vous contribuez au financement d'un kit scolaire")
OfferDon.create!(amount: 50, story: "Vous contribuez au financement d'un kit scolaire")
OfferDon.create!(amount: 80, story: "Vous contribuez au financement d'un kit scolaire")

MoneyDivision.create!(part: 23, use: "Traitement & Recherche")
MoneyDivision.create!(part: 27, use: "Traitement & Recherche")
MoneyDivision.create!(part: 25, use: "Traitement & Recherche")
MoneyDivision.create!(part: 25, use: "Traitement & Recherche")