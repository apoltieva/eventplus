class ModifyReferenceOfPerformersOnEvents < ActiveRecord::Migration[6.1]
  def change
    remove_reference :events, :performer
    add_reference :events, :performer, index: true,
                  foreign_key: true,
                  on_delete: :nullify
  end
end
