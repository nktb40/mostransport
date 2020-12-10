class IsochronesController < ApplicationController

	def get_routes
		@routes = Station.find_by(source_id: params[:station_id], city_id: params[:city_id]).routes
		render json: @routes.to_json, status: :ok
	end

	def get_changes_routes
		@routes = Route.where(route_code: params[:route_codes], city_id: params[:city_id])
		render json: @routes.to_json, status: :ok
	end

	def get_isochrones
		params[:with_interval] = nil if params[:with_interval].blank?
		
		@isochrones = Isochrone.where(profile: params[:profile], city_id: params[:city_id])
		@isochrones = @isochrones.where(source_station_id: params[:station_id]) if params[:station_id].present?
		@isochrones = @isochrones.where(with_interval: params[:with_interval]) if params[:with_interval].present?
		@isochrones = @isochrones.where(with_changes: params[:with_changes]) if params[:with_changes].present?
		@isochrones = @isochrones.where(contour: params[:contour]) if params[:contour].present?

		@routes = []
		@routes = Station.find_by(source_id: params[:station_id], city_id: params[:city_id]).routes if params[:show_routes]

	end

	def get_metrics
		metrics = Metric.where(isochrone_id: params[:isochrone_ids])
			.joins(:metric_type)
			.joins(:isochrone)
			.select("metric_types.metric_code, metric_types.metric_name, isochrones.contour, metrics.isochrone_unique_code, metrics.metric_value")

		@results = []
		
		metrics.map(&:metric_name).uniq.each do |code|
			result = {name: code}
			values = metrics.filter{|m| m.metric_name == code}.map{|m| "\"#{m.contour}\": #{m.metric_value}"}.join(', ')
			result['metrics'] = JSON.parse("{#{values}}")
			@results.push(result)
		end

		render json: @results, status: :ok
	end

end
