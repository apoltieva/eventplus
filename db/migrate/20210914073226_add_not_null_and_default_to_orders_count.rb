class AddNotNullAndDefaultToOrdersCount < ActiveRecord::Migration[6.1]
  def change
    change_column_null :events, :orders_count, false
    change_column_default :events, :orders_count, 0
  end
end
