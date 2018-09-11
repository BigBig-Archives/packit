class ItemsRelationsAndName < ActiveRecord::Migration[5.2]
  def change
    rename_table :item_refs, :item_references
    remove_column :bags, :reference_id
  end
end
