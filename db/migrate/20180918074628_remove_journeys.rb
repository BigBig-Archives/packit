class RemoveJourneys < ActiveRecord::Migration[5.2]
  def change
    remove_column :packed_bags, :journey_id
    drop_table :journeys
  end
end
