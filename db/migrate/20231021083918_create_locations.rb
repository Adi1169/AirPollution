class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :state
      t.string :country
      t.float :lat
      t.float :lon
      t.timestamps
      # avoid duplicate locations
      t.index [:lat, :lon], unique: true
    end
  end
end
