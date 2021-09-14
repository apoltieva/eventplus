class CreatePerformer < ActiveRecord::Migration[6.1]
  def change
    create_table :performers do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :events_performers do |t|
      t.belongs_to :event
      t.belongs_to :performer
    end

    remove_column :events, :artist
  end
end
