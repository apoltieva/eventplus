# frozen_string_literal: true

class DropActiveStoragePsql < ActiveRecord::Migration[6.1]
  def change
    drop_table :active_storage_postgresql_files
  end
end
