class Flight < ApplicationRecord
  belongs_to :to_airport, :class_name => 'Airport', :foreign_key => :to_airport_id
  belongs_to :from_airport, :class_name => 'Airport', :foreign_key => :from_airport_id
  has_many :flight_bundle_flights
  belongs_to :airline

  # validates :departure_datetime, presence: true
  # validates :arrival_datetime, presence: true
  # validates :price, presence: true
  # validates :flight_duration, presence: true
  # validates :from_airport_id, presence: true
  # validates :to_airport_id, presence: true
end
