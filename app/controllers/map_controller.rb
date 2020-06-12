class MapController < ApplicationController

	def get_routes
		@routes = Station.find_by(source_id: params[:station_id]).routes
		render json: @routes.to_json, status: :ok
	end

	def get_isochrones
		params[:with_interval] = nil if params[:with_interval].blank?
		
		#@isochrones = Station.where(source_id: params[:station_id]).
		@isochrones = Isochrone.where(source_station_id: params[:station_id], profile: params[:profile])
		@isochrones = @isochrones.where(with_interval: params[:with_interval]) if params[:with_interval].present?
		@isochrones = @isochrones.where(contour: params[:contour]) if params[:contour].present?

		render json: @isochrones.to_json, status: :ok
	end

	def get_metrics
		metrics = Metric.where(isochrone_unique_code: params[:isochrone_codes])
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
