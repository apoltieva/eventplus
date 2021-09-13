# frozen_string_literal: true

class Event < ApplicationRecord
  extend OrderAsSpecified

  validates_presence_of :title, :start_time, :end_time
  monetize :ticket_price_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :total_number_of_tickets, numericality: { greater_than_or_equal_to: 1 }

  belongs_to :venue
  has_many :orders, dependent: :destroy
  has_many :users, through: :orders
  has_many_attached :pictures

  scope :future, -> { where('end_time > ?', Time.now) }
  scope :past, -> { where('end_time <= ?', Time.now) }
  scope :future, -> { where('end_time > ?', Time.now) }
  scope :by_user, ->(id) { merge(User.find(id).events) if id }
  scope :nearest, ->(location) do
    order_as_specified venue_id: Venue.near(location, 20_000, units: :km).map(&:id)
  end
  scope :filter_by, ->(filter, location, user_id) do
    case filter
    when 'user'
      by_user(user_id).future.order(:start_time)
    when 'user_past'
      by_user(user_id).past.order(:start_time)
    when 'past'
      past.order(:start_time)
    when 'nearest'
      future.nearest(location)
    else
      order(:start_time)
    end
  end
end
