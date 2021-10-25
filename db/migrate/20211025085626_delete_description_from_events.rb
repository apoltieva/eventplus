class DeleteDescriptionFromEvents < ActiveRecord::Migration[6.1]
  def change
    remove_column :events, :description
  end
end
