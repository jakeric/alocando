# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

# flight = Flight.new(departure_datetime: Date.today, arrival_datetime: Date.today+1, price: 99.2, flight_duration: 17)

# Seed of cities and airports

if City.count != 3477
  # destroy all existing Airport datasets
  puts "detroy all airports..."
  Airport.destroy_all
  puts "airports destroyed"

  # parsing all airports and cities
  puts "get data from json..."
  airport_url = 'https://gist.githubusercontent.com/tdreyno/4278655/raw/7b0762c09b519f40397e4c3e100b097d861f5588/airports.json'
  airports_serialized = open(airport_url).read
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
else
  puts "Airports and Cities are already created, Sir."
end

# Seed of the airlines

if Airline.count != 806
  # destroy all existing Airport datasets
  puts "detroy all airlines and flights..."
  Airline.destroy_all
  Flight.destroy_all
  puts "airlines and flights has been destroyed"

  # parsing all airlines
  puts "getting json for the airlines..."
  airline_url = 'https://raw.githubusercontent.com/BesrourMS/Airlines/master/airlines.json'
  airlines_serialized = open(airline_url).read
  airlines = JSON.parse(airlines_serialized)

  puts "creating airlines now..."
  airlines.each do |airline|

    airline_acronym = airline["iata"]
    airline_name = airline["name"]

    new_airline = Airline.new(acronym: airline_acronym, name: airline_name).save if Airline.where("acronym = ?", airline_acronym) == []

  end
  puts "Created #{Airline.count} airlines."
else
  puts "Airlines are already created, Sir."
end

# deleting all the airports where city is nil
puts "deleting airports without a city"
Airport.where(city_id: nil).destroy_all
puts "airports without a city has been deleted"


# seeding flights
if Flight.count != 2000

  puts "deleting all the flights..."
  number_of_flights = Flight.count
  FlightBundleFlight.destroy_all
  FlightBundle.destroy_all
  Flight.destroy_all
  puts "#{number_of_flights} has been deleted."

  puts "creating flights..."
  # average speed of a plane 885 km/hr
  airplane_speed = 885.0

  4000.times do
    # get random start and end airport

    # Munich, Berlin, Paris, Lisbon, London, Madrid, Bratislava, Oslo, Reykjavik, Rome, Vienna, Warschau, Stockholm, Budapest
    start_airport = ['TXL','SXF','ORY','ZMU', 'LIS', 'LCY', 'ZDU', 'MAD', 'BTS', 'XZO', 'RKV', 'FCO', 'YNG', 'WAW', 'XEV', 'BUD'].sample

    # search for start airport city
    start_airport = Airport.where(acronym: start_airport)
    city_one = start_airport[0].city.name


    exclude_airports = Airport.where(city_id: start_airport[0].city_id).pluck(:acronym)

    end_airport = ['TXL','SXF','ORY','ZMU', 'LIS', 'LCY', 'ZDU', 'MAD', 'BTS', 'XZO', 'RKV', 'FCO', 'YNG', 'WAW', 'XEV', 'BUD']
    end_airport = end_airport - exclude_airports
    end_airport = end_airport.sample

    # search for end_airport city
    end_airport = Airport.where(acronym: end_airport)
    city_two = end_airport[0].city.name

    # get random airline
    airline = Airline.limit(1).order("RANDOM()")

    # calculate random start date
    departure_hour = rand(1..24)
    day_range = rand(1..10)
    departure_datetime = DateTime.now + day_range + (departure_hour / 24.0)

    # distance_url = "https://www.distance24.org/route.json?stops=#{city_one}|#{city_two}"
    # distance_serialized = open(distance_url).read
    # distance = JSON.parse(distance_serialized)

    # distance_km = distance["distance"]
    distance_km = 2316.0 # distance Lisbon - Berlin
    flight_duration = distance_km / airplane_speed
    # time_offset_hours = distance["travel"]["timeOffset"]["offsetMins"] / 60

    arrival_datetime = departure_datetime + (flight_duration / 24.0) #+ time_offset_hours

    price = rand(15..450)

    new_flight = Flight.new(
      departure_datetime: departure_datetime,
      arrival_datetime: arrival_datetime,
      price: price,
      flight_duration: flight_duration,
      from_airport_id: start_airport.ids.first,
      to_airport_id: end_airport.ids.first,
      airline_id: airline.ids.first
      )
    new_flight.save
    puts "100 flights created" if Flight.count == 100
    puts "200 flights created" if Flight.count == 200
    puts "300 flights created" if Flight.count == 300
    puts "400 flights created" if Flight.count == 400
    puts "500 flights created" if Flight.count == 500
    puts "600 flights created" if Flight.count == 600
    puts "700 flights created" if Flight.count == 700
    puts "800 flights created" if Flight.count == 800
    puts "900 flights created" if Flight.count == 900
  end
else
  puts "There are already 1000 flights, Sir."
end


# city description
# all_cities = ['Munich', 'Berlin', 'Paris', 'Lisbon', 'London', 'Madrid', 'Bratislava', 'Oslo', 'Reykjavik', 'Rome', 'Vienna', 'Warsaw', 'Stockholm', 'Budapest']
# all_cities.each do |city|

#   # get data from distance24 API
#   distance_url = "https://www.distance24.org/route.json?stops=#{city}|Tokyo"
#   distance_serialized = open(distance_url).read
#   distance = JSON.parse(distance_serialized)
#   description = distance["stops"][0]["wikipedia"]["abstract"]

#   # update the description of the city
#   city_to_update = City.where(name: city).first
#   city_to_update.description = description

#   # insert acitivities when we find something

#   # save city
#   city_to_update.save
# end

puts "You have just been seeded Duuuude."
