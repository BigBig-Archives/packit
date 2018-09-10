class RemoveSizeAndWeightFromBags < ActiveRecord::Migration[5.2]
  def change
    remove_column :bag_refs, :size
    remove_column :bag_refs, :weight
    remove_column :bags, :custom_size
    remove_column :bags, :custom_weight
  end
end
