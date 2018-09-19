class RemoveBags < ActiveRecord::Migration[5.2]
  def change
    remove_column :packed_bags, :bag_id
    drop_table :bags
    rename_table :packed_bags, :bags
  end
end
