class AddUrlToAirlines < ActiveRecord::Migration[5.2]
  def change
    add_column :airlines, :url, :string
  end
end
