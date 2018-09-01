class CreateJourneyBags < ActiveRecord::Migration[5.2]
  def change
    create_table :journey_bags do |t|
      t.references :journey, foreign_key: true
      t.references :packed_bag, foreign_key: true

      t.timestamps
    end
  end
end
