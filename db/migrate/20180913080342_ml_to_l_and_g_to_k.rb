class MlToLAndGToK < ActiveRecord::Migration[5.2]
  def change
    change_column :bag_templates, :capacity, :float, precision: 5, scale: 2
    change_column :bags, :capacity, :float, precision: 5, scale: 2
    change_column :item_references, :size, :float, precision: 5, scale: 2
    change_column :item_references, :weight, :float, precision: 5, scale: 2
    change_column :items, :size, :float, precision: 5, scale: 2
    change_column :items, :weight, :float, precision: 5, scale: 2
    change_column :packed_bags, :custom_load, :float, precision: 5, scale: 2
    change_column :packed_bags, :custom_weight, :float, precision: 5, scale: 2
  end
end
