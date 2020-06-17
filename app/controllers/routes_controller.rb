class RoutesController < ApplicationController

	def show
		@routes = Route.where(route_code: params[:route_codes])
	end
end