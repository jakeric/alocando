# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# # creating a city
# City.new(name: "Berlin", country: "Germany", description: "best city in the world").save

# # creating an airline
# Airline.new(name: "Lufthansa", acronym: "LHF").save

# # creating 2 airports
# txl = Airport.new(name: "Tegel", acronym: "TXL")
# txl.city = City.first
# txl.save
# sxf = Airport.new(name: "Schoenefeld", acronym: "SXF")
# sxf.city = City.last
# sxf.save

# flight = Flight.new(departure_datetime: Date.today, arrival_datetime: Date.today+1, price: 99.2, flight_duration: 17)

# destroy all existing Airport datasets
puts "detroy all airports..."
Airport.destroy_all
puts "airports destroyed"


# parsing all airports and cities
puts "get data from json..."
url = 'https://gist.githubusercontent.com/tdreyno/4278655/raw/7b0762c09b519f40397e4c3e100b097d861f5588/airports.json'
airports_serialized = open(url).read
airports = JSON.parse(airports_serialized)

puts "creating the airports and cities..."

airports.each do |airport|
  airport_code = airport["code"]
  airport_name = airport["name"]
  city_name = airport["city"]
  city_country = airport["country"]
  city_timezone = airport["tz"]

  # get city or create a new one
  if City.where("name = ?", city_name) == []
    new_city = City.new(name: city_name, country: city_country, timezone: city_timezone)
    new_city.save
    new_airport = Airport.new(name: airport_name, acronym: airport_code)
    new_airport.city = new_city
    new_airport.save
  else
    city = City.where("name = ?", city_name)
    new_airport = Airport.new(name: airport_name, acronym: airport_code, city_id: city.ids.first)
    # new_airport.city = city
    new_airport.save
  end
end

puts "Created #{Airport.count} airports and #{City.count} cities."

# destroy all existing Airport datasets
puts "detroy all airlines and flights..."
Airline.destroy_all
Flight.destroy_all
puts "airlines and flights has been destroyed"

# parsing all airlines
puts "getting json for the airlines..."
url = 'https://raw.githubusercontent.com/BesrourMS/Airlines/master/airlines.json'
airlines_serialized = open(url).read
airlines = JSON.parse(airlines_serialized)

puts "creating airlines now..."
airlines.each do |airline|

  airline_acronym = airline["iata"]
  airline_name = airline["name"]

  new_airline = Airline.new(acronym: airline_acronym, name: airline_name).save if Airline.where("acronym = ?", airline_acronym) == []

end

puts "Created #{Airline.count} airlines."

puts "You have just been seeded Duuuude."

