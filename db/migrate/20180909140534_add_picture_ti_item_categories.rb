class AddPictureTiItemCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :item_categories, :picture, :string
  end
end
