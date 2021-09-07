class CascadeDelete < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key "events", "venues"
    add_foreign_key "events", "venues", on_delete: :cascade
  end
end
