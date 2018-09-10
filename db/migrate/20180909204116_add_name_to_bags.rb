class AddNameToBags < ActiveRecord::Migration[5.2]
  def change
    add_column :bags, :name, :string
  end
end
