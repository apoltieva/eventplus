# frozen_string_literal: true

class Event < ApplicationRecord
  extend OrderAsSpecified

  validates_presence_of :title, :start_time, :end_time
  monetize :ticket_price_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :total_number_of_tickets, numericality: { greater_than_or_equal_to: 1 }

  belongs_to :venue
  has_many :orders, dependent: :destroy
  has_many :users, through: :orders
  belongs_to :performer
  accepts_nested_attributes_for :performer, reject_if: :all_blank, allow_destroy: true

  has_many_attached :pictures
  has_rich_text :description

  before_save :set_keywords

  scope :past, -> { where('end_time <= ?', Time.now) }
  scope :future, -> { where('end_time > ?', Time.now) }
  scope :by_user, ->(id) { merge(User.find(id).events) if id }
  scope :nearest, ->(ids) { future.order_as_specified(venue_id: ids) }
  scope :filter_by, ->(filter, user_id) do
    case filter
    when 'user'
      by_user(user_id).future.order(:start_time)
    when 'user_past'
      by_user(user_id).past.order(:start_time)
    when 'past'
      past.order(:start_time)
    else
      future.order(:start_time)
    end
  end
  scope :filter_by_keyword, ->(keyword) { where(':kwd = ANY(keywords)', kwd: keyword) }
  scope :with_keywords, -> { where('array_length(keywords, 1) > 0') }

  private

  def set_keywords
    return unless description.body_changed?

    self.keywords = DescriptionParser.keywords(description.to_plain_text.squish)
  end
end
