# frozen_string_literal: true

class Performer < ApplicationRecord
  has_many :listings
  has_many :events, through: :listings
end
