class AddForeignKeyPackedItemsToItemRefs < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :packed_items, :item_refs
  end
end
