class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name
      t.integer :category
      t.integer :size
      t.integer :weight
      t.string :picture

      t.timestamps
    end
  end
end
