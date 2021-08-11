class AddColumnsToVenue < ActiveRecord::Migration[6.1]
  def change
    change_table :venues do |t|
      t.string :name, null: false
      t.float :latitude, null: false
      t.float :longtitude, null: false
      t.integer :max_capacity
    end
  end
end
