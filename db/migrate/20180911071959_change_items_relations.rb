class ChangeItemsRelations < ActiveRecord::Migration[5.2]
  def change
    remove_column :bag_refs, :category_id
    drop_table :bag_categories
    add_reference :packed_items, :item, index: true
    rename_column :bags, :custom_capacity, :capacity
    add_column :bags, :picture, :string
    rename_column :items, :custom_size, :size
    rename_column :items, :custom_weight, :weight
    rename_column :items, :photo, :picture
    rename_table :bag_refs, :bag_templates
    remove_column :journeys, :country
    remove_column :journeys, :city
    add_column :journeys, :location, :string

  end
end
