class AddCategorieReferencesToItems < ActiveRecord::Migration[5.2]
  def change
    add_reference :item_refs, :category, foreign_key: true
    remove_column :item_refs, :category
  end
end
