# frozen_string_literal: true

class Event < ApplicationRecord
  validates_presence_of :title, :artist, :start_time, :end_time
  monetize :ticket_price_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :total_number_of_tickets, numericality: { greater_than_or_equal_to: 1 }
  belongs_to :venue
  has_many :orders
  has_many :users, through: :orders
  has_many_attached :pictures

  scope :future, -> { where('end_time > ?', Time.now) }
end
