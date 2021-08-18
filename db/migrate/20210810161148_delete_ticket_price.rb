class DeleteTicketPrice < ActiveRecord::Migration[6.1]
  def change
    remove_column :events, :ticket_price
  end
end
