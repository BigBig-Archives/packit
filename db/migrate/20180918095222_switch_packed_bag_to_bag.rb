class SwitchPackedBagToBag < ActiveRecord::Migration[5.2]
  def change
    rename_column :packed_items, :packed_bag_id, :bag_id
  end
end
