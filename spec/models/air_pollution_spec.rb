require "rails_helper"

RSpec.describe AirPollution, type: :model do
  describe '#average queries' do
    let!(:location) { FactoryBot.create(:location, state: "State") }
    let!(:location2) { FactoryBot.create(:location, state: "State2") }
    let!(:ap) { FactoryBot.create(:air_pollution, location: location, dt: DateTime.new(2022, 1, 1).to_i) }
    let!(:ap2) { FactoryBot.create(:air_pollution, location: location, dt: DateTime.new(2023, 2, 1).to_i) }
    let!(:ap3) { FactoryBot.create(:air_pollution, location: location2, dt: DateTime.new(2022, 3, 1).to_i) }
    let!(:ap4) { FactoryBot.create(:air_pollution, location: location2, dt: DateTime.new(2023, 4, 1).to_i) }

    it "gives correct average per location" do
      res = AirPollution.average_per_location
      expect(res.size).to eq(2)
      expect(res[0].average_aqi).to eq((ap.aqi + ap2.aqi) / 2.0)
    end

    it "gives correct average per month per location" do
      res = AirPollution.average_per_month_per_location
      expect(res.size).to eq(4)
      expect(res[0].average_aqi).to eq(ap.aqi)
      expect(res[0].year).to eq(2022)
      expect(res[0].month).to eq(1)
      expect(res[2].average_aqi).to eq(ap3.aqi)
      expect(res[2].year).to eq(2022)
      expect(res[2].month).to eq(3)
    end

    it "gives correct average per state" do
      res = AirPollution.average_per_state
      expect(res.size).to eq(2)
      expect(res[0].average_aqi).to eq((ap.aqi + ap2.aqi) / 2.0)
      expect(res[1].average_aqi).to eq((ap3.aqi + ap4.aqi) / 2.0)
    end
  end
end
