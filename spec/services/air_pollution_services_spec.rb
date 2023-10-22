require 'rails_helper'

RSpec.describe AirPollutionService do
  let(:api_key) { 'your_api_key' }
  let(:service) { AirPollutionService.new(api_key) }
  let(:lat) { 37.7749 }
  let(:lon) { -122.4194 }
  let(:response_body) { '{"list": [{"main": {"aqi": 2}, "dt": 1630477200, "components": {"co": 200, "no": 100, "no2": 150}}]}' }
  let(:base_uri) { 'http://api.openweathermap.org/data/2.5/air_pollution' }
  describe '#air_pollution_by_geo' do
    it 'returns air pollution data for a given location' do
      stub_request(:get, "#{base_uri}?appid=#{api_key}&lat=#{lat}&lon=#{lon}")
        .to_return(status: 200, body: response_body)
      result = service.air_pollution_by_geo(lat, lon)
      expect(result).to eq([{ aqi: 2, dt: 1630477200, components: { co: 200, no: 100, no2: 150 } }])
    end

    it 'raises an error if the API returns an error' do
      stub_request(:get, "#{base_uri}?appid=#{api_key}&lat=#{lat}&lon=#{lon}")
        .to_return(status: 401)
      expect { service.air_pollution_by_geo(lat, lon) }.to raise_error(AirPollutionServiceError)
    end
  end

  describe '#historical_air_pollution_by_geo' do
    it 'returns historical air pollution data for a given location and time range' do
      start_unix = 1630477200
      end_unix = 1630563600
      stub_request(:get, "#{base_uri}/history?appid=#{api_key}&end=#{end_unix}&lat=#{lat}&lon=#{lon}&start=#{start_unix}")
        .to_return(status: 200, body: response_body)
      result = service.historical_air_pollution_by_geo(lat, lon, start_unix, end_unix)
      expect(result).to eq([{ aqi: 2, dt: 1630477200, components: { co: 200, no: 100, no2: 150 } }])
    end

    it 'raises an error if the API returns an error' do
      start_unix = 1630477200
      end_unix = 1630563600
      stub_request(:get, "#{base_uri}/history?appid=#{api_key}&end=#{end_unix}&lat=#{lat}&lon=#{lon}&start=#{start_unix}")
        .to_return(status: 401)
      expect { service.historical_air_pollution_by_geo(lat, lon, start_unix, end_unix) }.to raise_error(AirPollutionServiceError)
    end
  end
end
