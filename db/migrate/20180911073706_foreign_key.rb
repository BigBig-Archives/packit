class ForeignKey < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :packed_bags, :journeys
    add_foreign_key :packed_items, :items
  end
end
