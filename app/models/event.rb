# frozen_string_literal: true

class Event < ApplicationRecord
  before_save :convert_money_to_cents

  validates_presence_of :title, :artist, :start_time, :end_time
  monetize :ticket_price_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :total_number_of_tickets, numericality: { greater_than_or_equal_to: 1 }
  belongs_to :venue
  has_many :orders
  has_many :users, through: :orders
  has_many_attached :pictures

  private

  def convert_money_to_cents
    # self.ticket_price_cents = (self.ticket_price_cents.to_f * 100).to_i
    p ticket_price_cents
  end
end
