class ChangeColumnItemRefToReference < ActiveRecord::Migration[5.2]
  def change
    rename_column :items, :item_ref_id, :reference_id
    rename_column :bags, :bag_ref_id, :reference_id
  end
end
