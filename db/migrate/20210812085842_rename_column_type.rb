class RenameColumnType < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      t.rename :type, :role
    end
  end
end
