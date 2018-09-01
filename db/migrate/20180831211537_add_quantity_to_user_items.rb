class AddQuantityToUserItems < ActiveRecord::Migration[5.2]
  def change
    add_column :user_items, :quantity, :integer
  end
end
