class City < ApplicationRecord
  has_many :airports

  validates :name, presence: true
  validates :country, presence: true
  # validates :description, presence: true
end
