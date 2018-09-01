class CreateUserItems < ActiveRecord::Migration[5.2]
  def change
    create_table :user_items do |t|
      t.references :user, foreign_key: true
      t.references :item, foreign_key: true
      t.string :commentary
      t.integer :custom_size
      t.integer :custom_weight
      t.string :photo

      t.timestamps
    end
  end
end
