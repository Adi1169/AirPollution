require 'rails_helper'

RSpec.describe ImportHistoricalAirPollutionWorker, type: :worker do
  describe '#perform' do
    let!(:location1) { FactoryBot.create(:location, lat: 40.7128, lon: -74.0060) }

    before do
      allow_any_instance_of(AirPollutionService).to receive(:historical_air_pollution_by_geo).and_return([{ aqi: 50, dt: 1, components: {co: 2} }, { aqi: 60, dt: 2, components: {co: 2}}])
    end

    it 'fetches historical air pollution data for each location and creates air pollution records' do
      expect {
        ImportHistoricalAirPollutionWorker.new.perform
      }.to change { AirPollution.count }.by(2)

      expect(location1.air_pollutions.count).to eq(2)
      expect(location1.air_pollutions.pluck(:aqi)).to eq([50, 60])
    end

    it 'doesnt insert if have same timestamp(dt)' do
      expect {
        ImportHistoricalAirPollutionWorker.new.perform
      }.to change { AirPollution.count }.by(2)
      expect {
        ImportHistoricalAirPollutionWorker.new.perform
      }.to change { AirPollution.count }.by(0)
    end
  end
end
