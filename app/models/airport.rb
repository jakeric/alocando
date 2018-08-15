class Airport < ApplicationRecord
  belongs_to :city
  has_many :from_airports, :class_name => 'Flight', :foreign_key => :from_airport_id
  has_many :to_airports, :class_name => 'Flight', :foreign_key => :to_airport_id

  # validates :name, presence: true
  # validates :acronym, presence: true
end
