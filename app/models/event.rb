# frozen_string_literal: true

class Event < ApplicationRecord
  validates_presence_of :title, :artist, :date
  has_one :venue
end
