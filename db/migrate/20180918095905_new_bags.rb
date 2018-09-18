class NewBags < ActiveRecord::Migration[5.2]
  def change
    remove_column :bags, :custom_load
    remove_column :bags, :custom_weight
    add_column    :bags, :capacity, :integer
    add_column    :bags, :picture, :string
    remove_column :items, :commentary
    remove_column :items, :picture
    remove_column :packed_items, :priority
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :photo
    remove_column :users, :size
    remove_column :users, :traveller_category
  end
end
