class RemoveQuantitiesFromItems < ActiveRecord::Migration[5.2]
  def change
    remove_column :user_items, :quantity
    remove_column :packed_items, :quantity
  end
end
