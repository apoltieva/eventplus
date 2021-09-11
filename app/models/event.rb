# frozen_string_literal: true

class Event < ApplicationRecord
  validates_presence_of :title, :start_time, :end_time
  monetize :ticket_price_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :total_number_of_tickets, numericality: { greater_than_or_equal_to: 1 }
  belongs_to :venue
  has_many :orders, dependent: :destroy
  has_many :users, through: :orders
  belongs_to :performer
  accepts_nested_attributes_for :performer, reject_if: :all_blank, allow_destroy: true
  has_many_attached :pictures

  scope :past, -> { where('end_time <= ?', Time.now) }
  scope :future, -> { where('end_time > ?', Time.now) }
  scope :by_user, ->(id) { merge(User.find(id).events) if id }
  scope :nearest, ->(location) {
    select('events.*, venues.*')
      .joins(:venue)
      .merge(Venue.near(location, 20_000, units: :km))
      .order('distance')
  }
  scope :filter_by, ->(filter, parameters) do
    case filter
    when 'user'
      by_user(parameters[:user_id]).future.order(:start_time)
    when 'user_past'
      by_user(parameters[:user_id]).past.order(:start_time)
    when 'past'
      past.order(:start_time)
    when 'nearest'
      future.nearest(parameters.fetch(:location))
    else
      order(:start_time)
    end
  end
end
