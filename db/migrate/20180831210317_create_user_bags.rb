class CreateUserBags < ActiveRecord::Migration[5.2]
  def change
    create_table :user_bags do |t|
      t.references :user, foreign_key: true
      t.references :bag, foreign_key: true
      t.integer :custom_size
      t.integer :custom_capacity
      t.integer :custom_weight

      t.timestamps
    end
  end
end
