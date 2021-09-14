class RenameEventsPerformersToListing < ActiveRecord::Migration[6.1]
  def change
    rename_table :events_performers, :listings
  end
end
