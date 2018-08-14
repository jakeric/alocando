class CreateCities < ActiveRecord::Migration[5.2]
  def change
    create_table :cities do |t|
      t.string :name
      t.string :country
      t.string :timezone
      t.string :description
      t.string :sight_one
      t.string :sight_two
      t.string :sight_three
      t.string :restaurant_one
      t.string :restaurant_two
      t.string :restaurant_three
      t.string :bar_one
      t.string :bar_two
      t.string :bar_three

      t.timestamps
    end
  end
end
