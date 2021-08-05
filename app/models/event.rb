# frozen_string_literal: true

class Event < ApplicationRecord
  validates_presence_of :title, :artist, :start_time, :end_time
  belongs_to :venue
  has_many_attached :pictures
end
