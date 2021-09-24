class RemoveListings < ActiveRecord::Migration[6.1]
  def change
    drop_table :listings
    add_reference :events, :performer, index: true, foreign_key: true
  end
end
