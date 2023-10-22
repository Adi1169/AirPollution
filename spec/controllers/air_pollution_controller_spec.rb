require 'rails_helper'

RSpec.describe AirPollutionController, type: :controller do
  let!(:location) { FactoryBot.create(:location, state: "State") }
  let!(:ap) { FactoryBot.create(:air_pollution, location: location, dt: DateTime.new(2022, 1, 1).to_i) }
  let!(:ap2) { FactoryBot.create(:air_pollution, location: location, dt: DateTime.new(2023, 2, 1).to_i) }

  describe '#average' do
    context 'when type is 1' do
      it 'returns the average air pollution per location' do
        get :average, params: { type: 1 }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)).to eq(AirPollution.average_per_location.as_json)
      end
    end

    context 'when type is 2' do
      it 'returns the average air pollution per month per location' do
        get :average, params: { type: 2 }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)).to eq(AirPollution.average_per_month_per_location.as_json)
      end
    end

    context 'when type is 3' do
      it 'returns the average air pollution per state' do
        get :average, params: { type: 3 }
        expect(response).to have_http_status(:success)
        expected_response = AirPollution.average_per_state.map { |avg| { state: avg.state, average_aqi: avg.average_aqi } }
        expect(JSON.parse(response.body)).to eq(expected_response.as_json)
      end
    end

    context 'when type is invalid' do
      it 'returns an error response' do
        get :average, params: { type: 4 }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Invalid type' })
      end
    end
  end
end
