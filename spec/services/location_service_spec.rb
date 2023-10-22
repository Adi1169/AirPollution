require 'rails_helper'
require 'webmock/rspec'

RSpec.describe LocationService do
  let(:api_key) { 'your_api_key' }
  let(:location_service) { LocationService.new(api_key) }
  let(:base_uri) { 'http://api.openweathermap.org/geo/1.0' }
  let(:response_body) { '[{"lat": 37.7749, "lon": -122.4194, "name": "San Francisco", "state": "California", "country": "United States"}]' }

  describe '#direct' do
    it 'returns the location data for a given query' do
      query = 'San Francisco'
      stub_request(:get, "#{base_uri}/direct?q=#{query}&limit=1&appid=#{api_key}")
        .to_return(status: 200, body: response_body)
      result = location_service.direct(query)
      expect(result).to eq({lat: 37.7749, lon: -122.4194, name: 'San Francisco', state: 'California', country: 'United States'})
    end

    it 'raises an error with the message from the API' do
      query = 'Invalid Query'
      error_message = 'Invalid query'
      stub_request(:get, "#{base_uri}/direct?q=#{query}&limit=1&appid=#{api_key}")
          .to_return(status: 400, body: { message: error_message }.to_json)
      expect { location_service.direct(query) }.to raise_error(LocationServiceError)
    end
  end

  describe '#reverse' do
    it 'returns the location data for a given latitude and longitude' do
      lat = 37.7749
      lon = -122.4194
      stub_request(:get, "#{base_uri}/reverse?lat=#{lat}&lon=#{lon}&limit=1&appid=#{api_key}")
        .to_return(status: 200, body: response_body)
      expect(location_service.reverse(lat, lon)).to eq({lat: 37.7749, lon: -122.4194, name: 'San Francisco', state: 'California', country: 'United States'})
    end

    it 'raises an error with the message from the API' do
      lat = 37.7749
      lon = -122.4194
      error_message = 'Invalid query'
      stub_request(:get, "#{base_uri}/reverse?lat=#{lat}&lon=#{lon}&limit=1&appid=#{api_key}")
        .to_return(status: 400, body: { message: error_message }.to_json)
      expect { location_service.reverse(lat, lon) }.to raise_error(LocationServiceError)
    end
  end
end