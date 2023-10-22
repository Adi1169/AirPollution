require 'rails_helper'

RSpec.describe ImportAirPollutionWorker, type: :worker do
  describe '#perform' do
    let!(:location1) { FactoryBot.create(:location, lat: 40.7128, lon: -74.0060) }
    let!(:location2) { FactoryBot.create(:location, lat: 50.7128, lon: -64.0060)}

    before do
      allow_any_instance_of(AirPollutionService).to receive(:air_pollution_by_geo).with(location1.lat, location1.lon).and_return([{ aqi: 50, dt: 1, components: {co: 2} }, { aqi: 60, dt: 2, components: {co: 2}}])
      allow_any_instance_of(AirPollutionService).to receive(:air_pollution_by_geo).with(location2.lat, location2.lon).and_raise(StandardError.new('Failed to fetch air pollution data'))
    end

    it 'fetches air pollution data for each location and creates air pollution records' do
      expect {
        ImportAirPollutionWorker.new.perform
      }.to change { AirPollution.count }.by(2)

      expect(location1.air_pollutions.count).to eq(2)
      expect(location1.air_pollutions.pluck(:aqi)).to eq([50, 60])

      expect(location2.air_pollutions.count).to eq(0)
    end

    it 'doesnt insert if have same timestamp(dt)' do
      expect {
        ImportAirPollutionWorker.new.perform
      }.to change { AirPollution.count }.by(2)
      expect {
        ImportAirPollutionWorker.new.perform
      }.to change { AirPollution.count }.by(0)
    end
  end
end