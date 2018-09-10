class ChangeReferenceForPackedItems < ActiveRecord::Migration[5.2]
  def change
    remove_column :packed_items, :item_id
    add_reference :packed_items, :item_ref, index: true
  end
end
