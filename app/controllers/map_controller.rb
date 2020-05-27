class MapController < ApplicationController

	def get_routes
		@routes = Station.find_by(source_id: params[:station_id]).routes
		render json: @routes.to_json, status: :ok
	end

	def get_isochrones
		@isochrones = Station.find_by(source_id: params[:station_id]).isochrones
		render json: @isochrones.to_json, status: :ok
	end
end
