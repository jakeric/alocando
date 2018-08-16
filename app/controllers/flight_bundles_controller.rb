class FlightBundlesController < ApplicationController
skip_before_action :authenticate_user!

  def index
    # implement search logic here

    # input from the search bar (homepage -> params)
    start_date = Date.today + 1
    end_date = Date.today + 3
    my_city = 'Berlin'
    friends_city = 'Munich'

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
    @bundle = []
    destination_airport_ids.each do |destination_airport_id|

      # find cheapest outbound flights
      my_city_flight = Flight.where("DATE(departure_datetime) = ?", start_date).where(to_airport: destination_airport_id, from_airport: my_airport_ids).order(price: :asc).limit(1).first
      friends_city_flight = Flight.where("DATE(departure_datetime) = ?", start_date).where(to_airport: destination_airport_id, from_airport: friends_airport_ids).order(price: :asc).limit(1).first
      # find cheapest return flights
      my_city_return_flight = Flight.where("DATE(arrival_datetime) = ?", end_date).where(to_airport: my_airport_ids, from_airport: destination_airport_id).order(price: :asc).limit(1).first
      friends_city_return_flight = Flight.where("DATE(arrival_datetime) = ?", end_date).where(to_airport: friends_airport_ids, from_airport: destination_airport_id).order(price: :asc).limit(1).first

      # creating a new flight_bundle
      new_bundle = FlightBundle.new
      new_bundle.save

      if my_city_flight.nil? || friends_city_flight.nil? || my_city_return_flight.nil? || friends_city_return_flight.nil?
        # if there are not enough flights, destroy the FlightBundle Object
        FlightBundle.find(new_bundle.id).destroy
      else
        # creating a new flight_bundle_flight which includes all the flights and the flight_bundle
        first_flight = FlightBundleFlight.new(flight: my_city_flight, flight_bundle_id: new_bundle.id)
        second_flight = FlightBundleFlight.new(flight: my_city_return_flight, flight_bundle_id: new_bundle.id)
        third_flight = FlightBundleFlight.new(flight: friends_city_flight, flight_bundle_id: new_bundle.id)
        fourth_flight = FlightBundleFlight.new(flight: friends_city_return_flight, flight_bundle_id: new_bundle.id)

        # save all the flight_bundle_flights
        first_flight.save
        second_flight.save
        third_flight.save
        fourth_flight.save

        # calculate the total_price for the flight_bundle and update
        new_bundle.total_price = my_city_flight.price + friends_city_flight.price + my_city_return_flight.price + friends_city_return_flight.price
        new_bundle.save

        # fill bundle array which will be returned in the result page
        @bundle << new_bundle
      end
    end

    # sort object by total_price
    @bundle.replace @bundle.sort_by {|flight_bundle| flight_bundle.total_price}

    # return @bundle as an array
    return @bundle
  end

  def show
  end

  def create
  end

  def destroy
  end

end
