class RoutesController < ApplicationController

	def show
		route_codes = params[:route_codes]
		@routes = Route.where(route_code: route_codes, city_id: params[:city_id])
		
		route_ids = @routes.ids

		@stations = LnkStationRoute.joins(:station).where(route_id: route_ids)
					.select("station_id, stations.station_name, stations.source_id, route_id, track_no, seq_no")

		isochrones = Isochrone.where(route_id: route_ids, profile: "route_cover", contour: 5)
		@isochrones = isochrones.map(&:geo_data)

		@isochrone_metrics = isochrones.joins(:metrics).joins('INNER JOIN metric_types ON metrics.metric_type_id = metric_types.id').select('route_id, metric_value, metric_name')

		return @routes
	end

	def get_city_routes
		@routes = Route.where(city_id: params[:city_id])
	end
end