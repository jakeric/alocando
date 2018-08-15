class FlightBundlesController < ApplicationController

  def index
    # implement search logic here
    start_date = DateTime.now + 5
    end_date = DateTime.now + 7
    my_city = 'Berlin'
    friends_city = 'Lisbon'

    airport_ids = Airport.includes(:city).where(cities: { name: [my_city,friends_city] }).pluck(:id)

    Flight.where(departure_datetime: start_date.to_date, from_airport: airport_ids)
  end

  def show
  end

  def create
  end

  def destroy
  end

end
