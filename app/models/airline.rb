class Airline < ApplicationRecord
  has_many :flights

  validates :name, presence: true
  validates :acronym, presence: true
end
