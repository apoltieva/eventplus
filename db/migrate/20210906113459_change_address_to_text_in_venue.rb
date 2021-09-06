class ChangeAddressToTextInVenue < ActiveRecord::Migration[6.1]
  def change
    change_column :venues, :address, :text
  end
end
