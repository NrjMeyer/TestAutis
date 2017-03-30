# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')

Offer.create!(amount: 50, mensualisable: false)
Offer.create!(amount: 60, mensualisable: true)
Offer.create!(amount: 120, mensualisable: true)

Role.create!(name: 'Parent')
Role.create!(name: 'Professeur')