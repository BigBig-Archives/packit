class RenameBagsToRef < ActiveRecord::Migration[5.2]
  def change
    rename_table :bags, :bag_refs
  end
end
