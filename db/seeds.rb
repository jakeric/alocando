# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# creating a city
City.new(name: "Berlin", country: "Germany", description: "best city in the world").save

# creating an airline
Airline.new(name: "Lufthansa", acronym: "LHF").save

# creating 2 airports
txl = Airport.new(name: "Tegel", acronym: "TXL")
txl.city = City.first
txl.save
sxf = Airport.new(name: "Schoenefeld", acronym: "SXF")
sxf.city = City.last
sxf.save


flight = Flight.new(departure_datetime: Date.today, arrival_datetime: Date.today+1, price: 99.2, flight_duration: 17)
