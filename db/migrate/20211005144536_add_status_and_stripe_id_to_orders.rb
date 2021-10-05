class AddStatusAndStripeIdToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :status, :integer, default: 0
    add_column :orders, :stripe_id, :string
    add_index :orders, :stripe_id, unique: true
  end
end
