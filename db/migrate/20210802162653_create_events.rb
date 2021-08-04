# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.string :description
      t.binary :picture
      t.integer :venue_id
      t.string :artist, null: false
      t.date :date, null: false
      t.time :start_time
      t.time :end_time
      t.integer :ticket_price
      t.integer :total_number_of_tickets

      t.timestamps
    end
  end
end
