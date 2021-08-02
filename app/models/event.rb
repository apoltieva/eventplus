# frozen_string_literal: true

class Event < ApplicationRecord
  validates_presence_of :title, :artist, :date
  has_one :venue_id
  has_one_attached :picture
end
