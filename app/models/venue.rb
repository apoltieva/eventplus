# frozen_string_literal: true

class Venue < ApplicationRecord
  validates_presence_of :name, :latitude, :longitude
  validates :longitude, inclusion: -180..180
  validates :latitude, inclusion: -90..90
  has_many_attached :pictures
  has_many :events
end
