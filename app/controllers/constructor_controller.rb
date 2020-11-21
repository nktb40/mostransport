class ConstructorController < ApplicationController
	def index
		if params[:city].present?
			@default_city = params[:city]
		else
			@default_city = 'MSK'
		end
	end

	def get_layers
		@layers = Layer.where(city_id: params[:city_id])
	end	

	def get_station_info
		station_source_id = params[:station_source_id]
		selected_city_id = params[:selected_city_id]

		@station = Station.find_by(source_id: station_source_id, city_id: selected_city_id)
		@isochrone = Isochrone.find_by(station_id: @station.id, contour: 5, profile: 'walking')
		@metrics = StationMetric.where(station_id: @station.id).map{|m| {metric_name:m.metric_type.metric_name, metric_value:m.metric_value, unit_code:m.metric_type.unit_code}}
		@metrics.concat(Metric.where(isochrone_id: @isochrone.id).map{|m| {metric_name:m.metric_type.metric_name, metric_value:m.metric_value, unit_code:m.metric_type.unit_code}})
		@routes = @station.routes.map{|r| {id:r.id, route_code: r.route_code, geo_data: r.geo_data, color: "#" + "%06x" % (rand * 0xffffff)}}
	end
end