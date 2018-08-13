class CreateFlightBundleFlights < ActiveRecord::Migration[5.2]
  def change
    create_table :flight_bundle_flights do |t|
      t.references :flight, foreign_key: true
      t.references :flight_bundle, foreign_key: true

      t.timestamps
    end
  end
end
