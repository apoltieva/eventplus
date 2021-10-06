# frozen_string_literal: true

require 'securerandom'

class Order < ApplicationRecord
  include Stripe::Callbacks

  before_validation :set_uuid
  belongs_to :user
  belongs_to :event
  after_checkout_succeded :update_counter_in_event

  validates_presence_of :event_id, :user_id, :uuid, :quantity
  validates_numericality_of :quantity, greater_than_or_equal_to: 0, only_integer: true
  validates_uniqueness_of :uuid

  enum status: %i[created success failure]

  private

  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  def update_counter_in_event
    event.update_column(:orders_count,
                        Order.where(event_id: event_id, status: :success).sum(:quantity))
  end
end
