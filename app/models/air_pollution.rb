class AirPollution < ApplicationRecord
  belongs_to :location
  validates_presence_of :aqi, :dt, :components, :location_id
  validates_uniqueness_of :dt, scope: :location_id

  include AirPollution::Averageable
end
