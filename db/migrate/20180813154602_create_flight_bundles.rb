class CreateFlightBundles < ActiveRecord::Migration[5.2]
  def change
    create_table :flight_bundles do |t|
      t.float :total_price

      t.timestamps
    end
  end
end
