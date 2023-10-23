class ImportAirPollutionWorker
  include Sidekiq::Worker

  def perform()
    Rails.logger.info("Fetching air pollution data")

    aps = AirPollutionService.new(Rails.application.credentials.dig(:open_weather, :api_key))

    Location.find_each do |location|
      begin
        res = aps.air_pollution_by_geo(location.lat, location.lon)
        location.air_pollutions.insert_all(res)
      rescue StandardError => e
        Rails.logger.error("Failed to fetch #{e.message}}")
      end
    end

    Rails.logger.info("Finished fetching air pollution data")
  end
end
