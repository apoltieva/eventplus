# frozen_string_literal: true

class Performer < ApplicationRecord
  has_many :events, dependent: :nullify
  validates_presence_of :name, allow_blank: false, allow_nil: false,
                        message: "- performer's name can't be blank!"
end
