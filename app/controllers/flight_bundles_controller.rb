require 'pixabay'
class FlightBundlesController < ApplicationController
skip_before_action :authenticate_user!

  def index

    # implement search logic here
    #byebug
    # input from the search bar (homepage -> params)
    date_array = flight_bundle_params["start-date"].split(" to ")

    start_date = date_array[0]
    end_date = date_array[1]
    my_city = flight_bundle_params["your-city"].split(" (")[0]
    friends_city = flight_bundle_params["friends-city"].split(" (")[0]

    @search_params =  {"your-city": my_city, "friends-city": friends_city, "start-date": flight_bundle_params["start-date"]}


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

    if @bundle.size == 0
      flash[:notice] = 'We are really sorry, we couldn\'t find any flights matching your search...'
      redirect_back(fallback_location: home_path)

    else
      # sort object by total_price
      @bundle.replace @bundle.sort_by {|flight_bundle| flight_bundle.total_price}

      # build an array with all destination cities and delete the duplicates which are more expansive
      destination_cities = []

      @bundle.each do |flight_bundle|
        destination_city = flight_bundle.flight_bundle_flights.first.flight.to_airport.city.name
        if destination_cities.include?(destination_city)
          @bundle.delete(flight_bundle)
        else
          destination_cities << flight_bundle.flight_bundle_flights.first.flight.to_airport.city.name
        end
      end


      # Checking for AJAX if it is the first load of the page or an AJAX request
      if flight_bundle_params.key?('flight_bundle')
        @bundle_id = flight_bundle_params["flight_bundle"]
      else
        @bundle_id = @bundle[0].id
        # Cuty.where global request - then pass this var in js render, then adapt the destination card code
      end

      @pictures_hash = {}
        @bundle.each do |flight_bundle|
          @city = flight_bundle.flight_bundle_flights.first.flight.to_airport.city.name
          @id = flight_bundle.id
          @image_array = []
          Pixabay.new(width:100, height:100).search(@city).each { |el| @image_array << el[:url] }
          @url = @image_array[0]
          @pictures_hash["#{@id}"] = @url
        end

    end

    # quotes [author, quote]
    # suorce: https://www.roughguides.com/gallery/50-inspirational-travel-quotes/
    quote_one = ['Gustave Flaubert','Travel makes one modest, you see what a tiny place you occupy in the world.']
    quote_two = ['Mark Twain','Travel is fatal to prejudice, bigotry, and narrow-mindedness.']
    quote_three = ['Henry Miller',"One's destination is never a place, but always a new way of seeing things."]
    quote_four = ["George Bernard Shaw","I dislike feeling at home when I'm abroad."]
    quote_five = ["Dagobert D. Runes","People travel to faraway places to watch, in fascination, the people they ignore at home."]
    quote_six = ["Henry David Thoreau","Not until we are lost do we begin to understand ourselves."]
    quote_seven = ["Aldous Huxley","For the born traveller, travelling is a besetting vice. Like other vices, it is imperious, demanding its victim's time, money, energy and the sacrifice of comfort."]
    quote_eight = ["Benjamin Disraeli","Like all great travellers, I have seen more than I remember, and remember more than I have seen."]
    quote_nine = ["T.S. Eliot","The journey not the arrival matters."]
    quote_ten = ["Kurt Vonnegut","Bizarre travel plans are dancing lessons from God."]
    quote_eleven = ["Oscar Wilde","I never travel without my diary. One should always have something sensational to read in the train."]
    quote_twelve = ["Marcel Proust","The real voyage of discovery consists not in seeing new landscapes, but in having new eyes."]
    quote_thirteen = ["Seneca", "Travel and change of place impart new vigour to the mind."]
    quote_fourteen = ["Martin Buber","All journeys have secret destinations of which the traveller is unaware."]
    quote_fivteen = ["Robert Frost","Two roads diverged in a wood and I – I took the one less travelled by."]
    quote_sixteen = ["Paul Theroux","Tourists don't know where they've been, travellers don't know where they're going."]
    quote_seventeen = ["Lao Tzu","A good traveller has no fixed plans and is not intent on arriving."]
    quote_eighteen = ["John Steinbeck","A journey is like marriage. The certain way to be wrong is to think you control it."]
    quote_nineteen = ["Albert Einstein","I love to travel, but hate to arrive."]

    @quote_array = [quote_one,quote_two,quote_three,quote_four,quote_five,quote_six,quote_seven,quote_eight,quote_nine,quote_ten,quote_eleven,quote_twelve,quote_thirteen,quote_fourteen,quote_fivteen,quote_sixteen,quote_seventeen,quote_eighteen,quote_nineteen]
    @quote_array.shuffle!

  end

  def show
    # show the location you chose on the result page
    @flight_bundle = FlightBundle.find(params[:id])
    @flight_bundle_flights = @flight_bundle.flight_bundle_flights

    # quotes [author, quote]
    # suorce: https://www.roughguides.com/gallery/50-inspirational-travel-quotes/
    quote_one = ['Gustave Flaubert','Travel makes one modest, you see what a tiny place you occupy in the world.']
    quote_two = ['Mark Twain','Travel is fatal to prejudice, bigotry, and narrow-mindedness.']
    quote_three = ['Henry Miller',"One's destination is never a place, but always a new way of seeing things."]
    quote_four = ["George Bernard Shaw","I dislike feeling at home when I'm abroad."]
    quote_five = ["Dagobert D. Runes","People travel to faraway places to watch, in fascination, the people they ignore at home."]
    quote_six = ["Henry David Thoreau","Not until we are lost do we begin to understand ourselves."]
    quote_seven = ["Aldous Huxley","For the born traveller, travelling is a besetting vice. Like other vices, it is imperious, demanding its victim's time, money, energy and the sacrifice of comfort."]
    quote_eight = ["Benjamin Disraeli","Like all great travellers, I have seen more than I remember, and remember more than I have seen."]
    quote_nine = ["T.S. Eliot","The journey not the arrival matters."]
    quote_ten = ["Kurt Vonnegut","Bizarre travel plans are dancing lessons from God."]
    quote_eleven = ["Oscar Wilde","I never travel without my diary. One should always have something sensational to read in the train."]
    quote_twelve = ["Marcel Proust","The real voyage of discovery consists not in seeing new landscapes, but in having new eyes."]
    quote_thirteen = ["Seneca", "Travel and change of place impart new vigour to the mind."]
    quote_fourteen = ["Martin Buber","All journeys have secret destinations of which the traveller is unaware."]
    quote_fivteen = ["Robert Frost","Two roads diverged in a wood and I – I took the one less travelled by."]
    quote_sixteen = ["Paul Theroux","Tourists don't know where they've been, travellers don't know where they're going."]
    quote_seventeen = ["Lao Tzu","A good traveller has no fixed plans and is not intent on arriving."]
    quote_eighteen = ["John Steinbeck","A journey is like marriage. The certain way to be wrong is to think you control it."]
    quote_nineteen = ["Albert Einstein","I love to travel, but hate to arrive."]

    @quote_array = [quote_one,quote_two,quote_three,quote_four,quote_five,quote_six,quote_seven,quote_eight,quote_nine,quote_ten,quote_eleven,quote_twelve,quote_thirteen,quote_fourteen,quote_fivteen,quote_sixteen,quote_seventeen,quote_eighteen,quote_nineteen]
    @quote_array.shuffle!

  end


  private

  def flight_bundle_params
   params.permit("your-city", "friends-city", "start-date", "flight_bundle")
  end

end
