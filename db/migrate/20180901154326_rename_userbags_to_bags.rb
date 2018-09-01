class RenameUserbagsToBags < ActiveRecord::Migration[5.2]
  def change
    rename_table :user_bags, :bags
  end
end
