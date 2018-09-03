class AddCategoryReferenceToBags < ActiveRecord::Migration[5.2]
  def change
    add_reference :bag_refs, :bag_category, foreign_key: true
    remove_column :bag_refs, :category
  end
end
