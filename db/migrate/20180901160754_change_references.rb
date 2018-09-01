class ChangeReferences < ActiveRecord::Migration[5.2]
  def change
    rename_column :bags, :bag_id, :bag_ref_id
    rename_column :items, :item_id, :item_ref_id
    rename_column :packed_bags, :user_bag_id, :bag_id
    rename_column :packed_items, :user_item_id, :item_id
  end
end
