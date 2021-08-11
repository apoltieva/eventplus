# frozen_string_literal: true

class Event < ApplicationRecord
  validates_presence_of :title, :artist, :start_time, :end_time
  monetize :ticket_price_cents, numericality: { greater_than_or_equal_to: 0 }
  belongs_to :venue
  has_many_attached :pictures
end
