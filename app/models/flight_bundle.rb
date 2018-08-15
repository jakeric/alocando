class FlightBundle < ApplicationRecord
  has_many :flight_bundle_flights
  has_many :flights, through: :flight_bundle_flights

end
