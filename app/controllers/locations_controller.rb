class LocationsController < ApplicationController
  def index
    render json: Location.all
  end

  def show
    render json: Location.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Location not found' }, status: :not_found
  end

  def create_location_using_coordinates
    ls = LocationService.new(Rails.application.credentials.dig(:open_weather, :api_key))
    location = ls.reverse(params[:lat], params[:lon])
    Location.create!(location)
    render json: location, status: :created
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end

  def create_location_direct
    ls = LocationService.new(Rails.application.credentials.dig(:open_weather, :api_key))
    location = ls.direct(params[:q])
    Location.create!(location)
    render json: location, status: :created
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end
end
