class Flight < ApplicationRecord
  has_one :to_airport_id :class_name => “airport”
  has_one :from_airport_id :class_name => “airport”
  has_many :flight_bundle_flights
  belongs_to :airline

  validates :departure_datetime, presence: true
  validates :arrival_datetime, presence: true
  validates :price, presence: true
  validates :flight_duration, presence: true
  validates :from_airport_id, presence: true
  validates :to_airport_id, presence: true

end
