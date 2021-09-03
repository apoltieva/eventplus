# frozen_string_literal: true

class Event < ApplicationRecord
  validates_presence_of :title, :artist, :start_time, :end_time
  monetize :ticket_price_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :total_number_of_tickets, numericality: { greater_than_or_equal_to: 1 }

  belongs_to :venue
  has_many :orders
  has_many :users, through: :orders
  has_many_attached :pictures

  scope :past, -> { where('end_time <= ?', Time.now) }
  scope :future, -> { where('end_time > ?', Time.now) }
  scope :user, ->(id) { merge(User.find(id).events) if id }
  scope :nearest, ->(location) {
                    select('events.*, venues.*')
                      .joins(:venue)
                      .merge(Venue.near(location, 20_000, units: :km))
                      .order('distance')
                  }
  scope :filter_by, ->(filter, request, user_id) do
    case filter
    when 'user'
      user(user_id).future.order(:start_time)
    when 'user_past'
      user(user_id).past.order(:start_time)
    when 'past'
      past.order(:start_time)
    when 'nearest'
      location = if !request.remote_ip || request.remote_ip == '127.0.0.1'
                   'Kiev, Ukraine'
                 else
                   request.safe_location
                 end
      future.nearest(location)
    else
      all.order(:start_time)
    end
  end
end
