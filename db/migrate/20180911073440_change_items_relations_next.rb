class ChangeItemsRelationsNext < ActiveRecord::Migration[5.2]
  def change
    remove_column :packed_items, :item_ref_id
  end
end
