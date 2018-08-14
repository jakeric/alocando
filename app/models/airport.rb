class Airport < ApplicationRecord
  belongs_to :city
  has_many :from_airport_ids
  has_many :to_airport_ids

  validates :name, presence: true
  validates :acronym, presence: true
end
