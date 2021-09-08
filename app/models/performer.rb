# frozen_string_literal: true

class Performer < ApplicationRecord
  has_many :events, dependent: :nullify
end
