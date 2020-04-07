# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if Rails.env.development?
    Usuario.create!(nome: "Admin", email: 'admin@example.com', password: 'password', password_confirmation: 'password', admin: true) 
    Usuario.create!(nome: "Obi-Wan Kenobi", email: 'benkenobi@example.com', password: 'password', password_confirmation: 'password', admin: false)
    Usuario.create!(nome: "Darth Vader", email: 'anakin@example.com', password: 'password', password_confirmation: 'password', admin: false)
end