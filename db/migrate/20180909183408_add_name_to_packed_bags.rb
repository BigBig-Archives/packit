class AddNameToPackedBags < ActiveRecord::Migration[5.2]
  def change
    add_column :packed_bags, :name, :string
  end
end
