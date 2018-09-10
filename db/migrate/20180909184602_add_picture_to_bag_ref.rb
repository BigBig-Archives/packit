class AddPictureToBagRef < ActiveRecord::Migration[5.2]
  def change
    add_column :bag_refs, :picture, :string
  end
end
