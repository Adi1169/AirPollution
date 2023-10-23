
RSpec.describe LocationsController, type: :controller do
  let!(:location) { FactoryBot.create(:location, state: "State") }
  let!(:location2) { FactoryBot.create(:location, state: "State2") }

  describe 'GET #index' do
    it 'returns all locations' do
      get :index
      expect(JSON.parse(response.body)).to match_array([location.as_json, location2.as_json])
    end
  end

  describe 'GET #show' do
    context 'when location exists' do
      it 'returns a success response' do
        get :show, params: { id: location.id }
        expect(response).to be_successful
        expect(JSON.parse(response.body)).to eq(location.as_json)
      end
    end

    context 'when location does not exist' do
      it 'returns a not found response' do
        get :show, params: { id: 999 }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Location not found' })
      end
    end
  end

  describe 'POST #create_location_using_coordinates' do
    context 'when valid coordinates are provided' do
      let(:valid_params) { { lat: 40.7128, lon: -74.0060 } }

      it 'creates a new location' do
      allow_any_instance_of(LocationService).to receive(:reverse).and_return({'name' => 'New York', 'state' => 'New York', 'country' => 'US', 'lat' => 40.712, 'lon' => -74.0060})
        expect {
          post :create_location_using_coordinates, params: valid_params
        }.to change(Location, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to eq({"country"=>"US", "lat"=>40.712, "lon"=>-74.006, "name"=>"New York", "state"=>"New York"})
      end
    end

    context 'when invalid coordinates are provided' do
      let(:invalid_params) { { lat: 'invalid', lon: 'invalid' } }

      it 'returns a bad request response' do
        allow_any_instance_of(LocationService).to receive(:reverse).and_raise(LocationServiceError.new('Invalid coordinates'))
        post :create_location_using_coordinates, params: invalid_params
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Invalid coordinates' })
      end
    end
  end

  describe 'POST #create_location_direct' do
    context 'when valid query is provided' do
      let(:valid_params) { { q: 'New York' } }

      it 'creates a new location' do
        allow_any_instance_of(LocationService).to receive(:direct).and_return({'name' => 'New York', 'state' => 'New York', 'country' => 'US', 'lat' => 40.712, 'lon' => -74.0060})
        expect {
          post :create_location_direct, params: valid_params
        }.to change(Location, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to eq({"country"=>"US", "lat"=>40.712, "lon"=>-74.006, "name"=>"New York", "state"=>"New York"})
      end
    end

    context 'when invalid query is provided' do
      let(:invalid_params) { { q: '' } }
      it 'returns a bad request response' do
        allow_any_instance_of(LocationService).to receive(:direct).and_raise(LocationServiceError.new('Query cannot be blank'))
        post :create_location_direct, params: invalid_params
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Query cannot be blank' })
      end
    end
  end
end
