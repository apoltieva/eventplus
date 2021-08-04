class RenameColInVenue < ActiveRecord::Migration[6.1]
  def change
    change_table :venues do |t|
      t.rename :longtitude, :longitude
    end
  end
end
