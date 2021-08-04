# frozen_string_literal: true

class AlterEvent < ActiveRecord::Migration[6.1]
  def change
    remove_column :events, :date
    remove_column :events, :picture
    remove_column :events, :start_time, :timestamp, precision: 6, null: false
    remove_column :events, :end_time, :timestamp, precision: 6, null: false
    remove_column :events, :venue_id
  end
end
