class AddCounterCacheForOrdersInEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :orders_count, :integer
  end
end
