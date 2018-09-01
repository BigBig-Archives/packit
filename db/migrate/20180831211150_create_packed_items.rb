class CreatePackedItems < ActiveRecord::Migration[5.2]
  def change
    create_table :packed_items do |t|
      t.references :packed_bag, foreign_key: true
      t.references :user_item, foreign_key: true
      t.integer :quantity
      t.integer :priority

      t.timestamps
    end
  end
end
