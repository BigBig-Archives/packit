class AddLatLonToJourney < ActiveRecord::Migration[5.2]
  def change
    add_column :journeys, :latitude, :float
    add_column :journeys, :longitude, :float
  end
end
