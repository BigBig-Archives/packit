class CreateBags < ActiveRecord::Migration[5.2]
  def change
    create_table :bags do |t|
      t.string :name
      t.integer :category
      t.integer :size
      t.integer :capacity
      t.integer :weight

      t.timestamps
    end
  end
end
