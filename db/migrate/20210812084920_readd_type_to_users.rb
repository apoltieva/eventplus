class ReaddTypeToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :type, :integer, default: 0
  end
end
