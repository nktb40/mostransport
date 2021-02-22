class RoutesController < ApplicationController

	def show
		@route = Route.find(params[:route_id])

		@stations = LnkStationRoute.joins(:station).where(route_id: @route.id)
					.select("station_id, stations.station_name, stations.source_id, route_id, track_no, seq_no, route_time, distance")

		isochrones = Isochrone.where(route_id: @route.id, profile: "route_cover", contour: 5)
		@isochrones = isochrones.map(&:geo_data)

		@isochrone_metrics = isochrones.joins(:metrics).joins('INNER JOIN metric_types ON metrics.metric_type_id = metric_types.id').select('route_id, metric_value, metric_name, metric_types.unit_code')
		
		@route_metrics = @route.route_metrics.joins(:metric_type).select("metric_types.metric_code, metric_types.metric_name, route_metrics.metric_value, metric_types.unit_code")
	end

	def get_city_routes
		@routes = Route.where(city_id: params[:city_id]).order(:route_code)
		@metrics = RouteMetric.where(route_id: @routes.ids).joins(:metric_type).where(metric_types:{metric_code: ['route_length','straightness','route_cost']}).select("route_metrics.route_id, metric_types.metric_code, metric_types.metric_name, route_metrics.metric_value, metric_types.unit_code")
	end
end