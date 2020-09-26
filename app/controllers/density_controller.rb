class DensityController < ApplicationController

	def index
	end
	
	def show
		@routes = Route.where(route_code: params[:route_codes], city_id: params[:city_id])
	end

end