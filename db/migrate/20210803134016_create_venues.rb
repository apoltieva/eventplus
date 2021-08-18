# frozen_string_literal: true

class CreateVenues < ActiveRecord::Migration[6.1]
  def change
    create_table :venues, &:timestamps
  end
end
