class RenameItemsToRef < ActiveRecord::Migration[5.2]
  def change
    rename_table :items, :item_refs
  end
end
