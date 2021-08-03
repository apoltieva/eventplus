class ReAddColumnsToEvent < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :start_time, :timestamp, precision: 6, null: false
    add_column :events, :end_time, :timestamp, precision: 6, null: false
  end
end