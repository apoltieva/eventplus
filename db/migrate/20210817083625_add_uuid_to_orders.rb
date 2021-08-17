class AddUuidToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :uuid, :string
  end
end
