class CreatePackedBags < ActiveRecord::Migration[5.2]
  def change
    create_table :packed_bags do |t|
      t.references :user_bag, foreign_key: true
      t.integer :custom_load
      t.integer :custom_weight

      t.timestamps
    end
  end
end
