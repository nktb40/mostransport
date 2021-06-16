class StationsController < ApplicationController

	def index
		@stations = Station.where(city_id: params[:city_id]).where(deleted_flag: false).where.not(station_name: "").order(:station_name)
		r2s = @stations.joins(:lnk_direction_stations).joins(:directions).select("stations.id as station_id, directions.route_id").map{|d| {station_id: d.station_id, route_id: d.route_id}}.uniq
		@routes = Route.where(id: r2s.map{|r| r[:route_id]}.uniq)
		@route2stations = r2s.map{|t| {station_id: t[:station_id], route_id: t[:route_id], route_code: @routes.find{|r| r.id == t[:route_id]}.route_code}}
	end

	def show
		@station = Station.find_by(id: params[:station_id])
		@walk_iso = Isochrone.find_by(station_id: @station.id, contour: 5, profile: 'walking')
		@metrics = StationMetric.where(station_id: @station.id).map{|m| {metric_code:m.metric_type.metric_code, metric_name:m.metric_type.metric_name, metric_value:m.metric_value, unit_code:m.metric_type.unit_code}}
		@metrics.concat(Metric.where(isochrone_id: @walk_iso.id).map{|m| {metric_code:m.metric_type.metric_code, metric_name:m.metric_type.metric_name, metric_value:m.metric_value, unit_code:m.metric_type.unit_code}})
		
		generator = ColorGenerator.new saturation: 0.9, lightness: 0.4
		directions = @station.directions
		@routes = Route.where(id: directions.map(&:route_id)).map{|r| {id:r.id, route_code: r.route_code, geo_data: directions.select{|d| d.route_id == r.id}.first.geo_data, color: "#" + generator.create_hex}}
	
		isochrones = []
		iso1 = Isochrone.find_by(station_id: @station.id, contour: 5, profile: 'walking')
		isochrones.append({type:"Feature", properties:{profile:iso1.profile}, geometry:iso1.geo_data}) if iso1.present?
		iso2 = Isochrone.find_by(station_id:@station.id, contour:30, profile: 'public_transport', with_interval: true, with_changes: false)
		isochrones.append({type:"Feature", properties:{profile:iso2.profile}, geometry:iso2.geo_data}) if iso2.present?
		iso3 = Isochrone.find_by(station_id:@station.id, contour:30, profile: 'public_transport', with_interval: true, with_changes: true)
		isochrones.append({type:"Feature", properties:{profile:iso3.profile+"_chng"}, geometry:iso3.geo_data}) if iso3.present?
		
		@isochrones_collection = {type:"FeatureCollection", features:isochrones}
	end


	def get_city_stations
		if params[:city_id].present?
			@stations = Station.where(city_id: params[:city_id]).where(deleted_flag: false).order(:station_name)
		elsif params[:project_id].present?
			@stations = Project.find(params[:project_id]).stations.where(deleted_flag: false).order(:station_name)
		end
	end

	def get_station_popup
		@station = Station.find_by(source_id: params[:station_source_id], city_id: params[:selected_city_id])
		@routes = Route.where(id: @station.directions.map(&:route_id))
	end
end