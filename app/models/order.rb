# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  belongs_to :event
  after_commit :update_counter_in_event

  private

  def update_counter_in_event
    event.update_column(:orders_count,
                        Order.where(event_id: event_id).sum(:quantity))
  end
end
