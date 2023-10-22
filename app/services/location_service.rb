require 'httparty'

class LocationService
  BASE_URI = 'http://api.openweathermap.org/geo/1.0'

  def initialize(api_key)
    @options = { query: { appid: api_key } }
  end

  def direct(q)
    # limit is hardcoded to 1 to make the location search and selection more simple
    location_response(HTTParty.get("#{BASE_URI}/direct?q=#{q}&limit=1", @options))
  end

  def reverse(lat, lon)
    # limit is hardcoded to 1 to make the location search and selection more simple
    location_response(HTTParty.get("#{BASE_URI}/reverse?lat=#{lat}&lon=#{lon}&limit=1", @options))
  end

  private

  def location_response(response)
    if response.code != 200
      raise LocationServiceError, response['message']
    end

    location_data = JSON.parse(response.body)
    if location_data.empty?
      raise LocationServiceError, 'No location found'
    end
    {lat: location_data[0]['lat'], lon: location_data[0]['lon'], name: location_data[0]['name'], state: location_data[0]['state'], country: location_data[0]['country']}
  end
end
