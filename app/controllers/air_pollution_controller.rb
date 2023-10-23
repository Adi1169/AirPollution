class AirPollutionController < ApplicationController
	def average
    case params[:type].to_i
    when 1
      render json: AirPollution.average_per_location
    when 2
      render json: AirPollution.average_per_month_per_location
    when 3
      # to remove the 'id' field from the response which is always null
      render json: AirPollution.average_per_state.map { |avg| { state: avg.state, average_aqi: avg.average_aqi } }
    else
      render json: { error: 'Invalid type' }, status: :bad_request
    end
	end
end
