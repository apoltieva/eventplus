class MonetizeEvent < ActiveRecord::Migration[6.1]
  def change
    add_monetize :events, :ticket_price
  end
end
