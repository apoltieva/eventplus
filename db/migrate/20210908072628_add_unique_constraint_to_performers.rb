class AddUniqueConstraintToPerformers < ActiveRecord::Migration[6.1]
  def change
    add_index :performers, [:name], unique: true
  end
end
