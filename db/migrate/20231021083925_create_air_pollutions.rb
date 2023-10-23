class CreateAirPollutions < ActiveRecord::Migration[7.1]
  def change
    create_table :air_pollutions do |t|
      t.integer :aqi
      t.integer :dt
      t.json :components
      t.references :location, null: false, foreign_key: true
      t.timestamps
      # avoid duplicate air_pollutions for the same location and time
      t.index [:dt, :location_id], unique: true
    end
  end
end
