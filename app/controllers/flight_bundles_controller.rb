class FlightBundlesController < ApplicationController

  def index
    # implement search logic here

    # input from the search bar (homepage)
    start_date = Date.today + 4
    end_date = Date.today + 7
    my_city = 'Berlin'
    friends_city = 'Lisbon'

    # search for all the available airports in my city and in the city of my friend
    my_airport_ids = Airport.includes(:city).where(cities: { name: my_city }).pluck(:id)
    friends_airport_ids = Airport.includes(:city).where(cities: { name: friends_city }).pluck(:id)

    # search for all flights from all city airports at the start date (input from the user)
    my_city_flights = Flight.where("DATE(departure_datetime) = ?", start_date).where(from_airport: my_airport_ids)
    friends_city_flights = Flight.where("DATE(departure_datetime) = ?", start_date).where(from_airport: friends_airport_ids)


    # check if there is a location where both flights are going on that date
    my_city_destinations = []
    my_city_flights.each do |flight|
      my_city_destinations << flight.to_airport
    end

    friends_city_destinations = []
    friends_city_flights.each do |flight|
      friends_city_destinations << flight.to_airport
    end

    destination_airport = []
    my_city_destinations.each do |airport_id|
      if friends_city_destinations.include?(airport_id)
        destination_airport << airport_id
      end
    end

    # generate an array of destination airport_ids
    destination_airport_ids = []
    destination_airport.each do |airport|
      destination_airport_ids << airport.id
    end

    # delete duplicates
    destination_airport_ids = destination_airport_ids.uniq

    # check if there are return flights from the location to both cities on the return date and find the cheapest one
    # alson building the bundles
    destination_airport_ids.each do |destination_airport_id|

      # find cheapest outbound flights
      my_city_flight = Flight.where("DATE(departure_datetime) = ?", start_date).where(to_airport: destination_airport_id, from_airport: my_airport_ids).order(price: :asc).limit(1)
      friends_city_flight = Flight.where("DATE(departure_datetime) = ?", start_date).where(to_airport: destination_airport_id, from_airport: friends_airport_ids).order(price: :asc).limit(1)
      # find cheapest return flights
      my_city_return_flight = Flight.where("DATE(arrival_datetime) = ?", end_date).where(to_airport: my_airport_ids, from_airport: destination_airport_id).order(price: :asc).limit(1)
      friends_city_return_flight = Flight.where("DATE(arrival_datetime) = ?", end_date).where(to_airport: friends_airport_ids, from_airport: destination_airport_id).order(price: :asc).limit(1)

      new_bundle = Bundle_bundle.new
      new_budnle.save
      Flight_bundle_flight.new(flight: my_city_flight, flight_bundle: new_bundle).save
      Flight_bundle_flight.new(flight: friends_city_flight, flight_bundle: new_bundle).save
      Flight_bundle_flight.new(flight: my_city_return_flight, flight_bundle: new_bundle).save
      Flight_bundle_flight.new(flight: friends_city_return_flight, flight_bundle: new_bundle).save
      new_bundle.price = my_city_flight.price + friends_city_flight.price + my_city_return_flight.price + friends_city_return_flight.price
      new_bundle.save
    end

  end

  def show
  end

  def create
  end

  def destroy
  end

end
