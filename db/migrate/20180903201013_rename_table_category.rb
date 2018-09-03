class RenameTableCategory < ActiveRecord::Migration[5.2]
  def change
    rename_table :categories, :item_categories
  end
end
