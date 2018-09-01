class CreateJourneys < ActiveRecord::Migration[5.2]
  def change
    create_table :journeys do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.date :start_date
      t.date :end_date
      t.integer :category
      t.string :country
      t.string :city
      t.string :photo

      t.timestamps
    end
  end
end
