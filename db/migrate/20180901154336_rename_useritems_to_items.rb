class RenameUseritemsToItems < ActiveRecord::Migration[5.2]
  def change
    rename_table :user_items, :items
  end
end
