class MapController < ApplicationController

	def get_routes
		@routes = Station.find_by(source_id: params[:station_id]).routes
		render json: @routes.to_json, status: :ok
	end

	def get_isochrones
		@isochrones = Station.find_by(source_id: params[:station_id]).isochrones
				.where(profile: params[:profile], with_interval: params[:with_interval])

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
			result['metrics'] = JSON.parse(metrics.filter{|m| m.metric_name == code}.map{|m| "{\"#{m.contour}\": #{m.metric_value}}"}.join(', '))
			@results.push(result)
		end

		puts @results
		render json: @results, status: :ok
	end
end
