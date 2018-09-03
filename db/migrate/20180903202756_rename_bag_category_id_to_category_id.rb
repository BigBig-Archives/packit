class RenameBagCategoryIdToCategoryId < ActiveRecord::Migration[5.2]
  def change
    rename_column :bag_refs, :bag_category_id, :category_id
  end
end
