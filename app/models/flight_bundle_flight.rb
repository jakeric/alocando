class FlightBundleFlight < ApplicationRecord
  belongs_to :flight
  belongs_to :flight_bundle
end
