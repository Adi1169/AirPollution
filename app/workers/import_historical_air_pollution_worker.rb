class ImportHistoricalAirPollutionWorker
  include Sidekiq::Worker

  def perform()
    Rails.logger.info("Fetching historical air pollution data")
    aps = AirPollutionService.new(Rails.application.credentials.dig(:open_weather, :api_key))
    
    # Fetch historical data for the last year
    endUnix = Time.now.to_i
    startUnix  = endUnix - 1.year
    Location.find_each do |location|
      begin
        res = aps.historical_air_pollution_by_geo(location.lat, location.lon, startUnix, endUnix)
        location.air_pollutions.insert_all(res)
      rescue StandardError => e
        Rails.logger.error("Failed to fetch #{e.message}}")
      end
    end

    Rails.logger.info("Finished fetching historical air pollution data")
  end
end
