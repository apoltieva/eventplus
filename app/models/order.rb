# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates_presence_of :event_id, :user_id, :uuid, :quantity
  validates_numericality_of :quantity, greater_than_or_equal_to: 0, only_integer: true
  validates_uniqueness_of :uuid
end
