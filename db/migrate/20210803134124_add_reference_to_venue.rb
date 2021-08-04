# frozen_string_literal: true

class AddReferenceToVenue < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :events, :venue, index: true, foreign_key: true
  end
end
