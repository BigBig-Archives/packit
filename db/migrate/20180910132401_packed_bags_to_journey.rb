class PackedBagsToJourney < ActiveRecord::Migration[5.2]
  def change
    drop_table :journey_bags
    add_reference :packed_bags, :journey, index: true
  end
end
