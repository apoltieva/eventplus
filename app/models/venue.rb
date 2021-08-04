class Venue < ApplicationRecord
  validates_presence_of :name, :latitude, :longitude
  has_many_attached :pictures
  has_many :events
end
