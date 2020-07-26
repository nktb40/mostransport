class RoutesController < ApplicationController

	def show
		@routes = Route.where(route_code: params[:route_codes], city_id: params[:city_id])
	end

	def get_city_routes
		@routes = Route.where(city_id: params[:city_id])
	end
end