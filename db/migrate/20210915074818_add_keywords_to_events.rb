class AddKeywordsToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :keywords, :string, array: true
    add_index :events, :keywords, using: 'gin'
  end
end
