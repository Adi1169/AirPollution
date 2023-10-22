require 'httparty'

class AirPollutionService
  BASE_URI = 'http://api.openweathermap.org/data/2.5/air_pollution'

  def initialize(api_key)
    @options = { query: { appid: api_key } }
  end

  def air_pollution_by_geo(lat, lon)
    air_pollution_response(HTTParty.get("#{BASE_URI}?lat=#{lat}&lon=#{lon}", @options))
  end

  def historical_air_pollution_by_geo(lat, lon, startUnix, endUnix)
    air_pollution_response(HTTParty.get("#{BASE_URI}/history?lat=#{lat}&lon=#{lon}&start=#{startUnix}&end=#{endUnix}", @options))
  end

  private

  def air_pollution_response(response)
    if response.code != 200
      raise AirPollutionServiceError, response['message']
    end
    pollution_data = JSON.parse(response.body)['list']
    result = []
    pollution_data.each do |pollution|
      result << {aqi: pollution['main']['aqi'], dt: pollution['dt'], components: pollution['components'].transform_keys(&:to_sym)}
    end
    result
  end
end