class City < ApplicationRecord
  has_many :airports
  has_many :attachments

  # validates :name, presence: true
  # validates :country, presence: true
  # validates :description, presence: true

end
