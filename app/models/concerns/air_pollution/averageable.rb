module AirPollution::Averageable
  extend ActiveSupport::Concern
  included do
    def self.average_per_location
      AirPollution.joins(:location)
              .group('locations.id')
              .select('locations.*, AVG(air_pollutions.aqi) AS average_aqi')
              .order('locations.id')
              .to_a
    end

    def self.average_per_month_per_location
      AirPollution.joins(:location)
              .group('year, month, locations.id')
              .select('locations.*, EXTRACT(YEAR FROM TO_TIMESTAMP(dt)) AS year, EXTRACT(MONTH FROM TO_TIMESTAMP(dt)) AS month, AVG(air_pollutions.aqi) AS average_aqi')
              .order('locations.id, year, month')
              .to_a
    end

    def self.average_per_state
      AirPollution.joins(:location)
              .group('locations.state')
              .select('locations.state, AVG(air_pollutions.aqi) as average_aqi')
              .order('locations.state')
              .to_a
    end
  end
end