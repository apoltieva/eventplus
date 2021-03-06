# frozen_string_literal: true

class Venue < ApplicationRecord
  validates_presence_of :name, :latitude, :longitude
  validates :longitude, inclusion: -180..180
  validates :latitude, inclusion: -90..90
  validates_uniqueness_of :name

  has_many_attached :pictures
  has_many :events, dependent: :destroy

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode, if: ->(obj) {
    (obj.latitude_changed? || obj.longitude_changed?)
  }
end
