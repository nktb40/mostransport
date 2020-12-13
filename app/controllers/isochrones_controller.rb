class IsochronesController < ApplicationController

	def show
		params[:with_interval] = nil if params[:with_interval].blank?

		# Получаем список изохронов
		@isochrones = get_isochrones(params)

		# Получаем список маршрутов, проходящих через точку
		@routes = (params[:show_routes] == "true") ? get_routes(params) : []

		# Получаем список пересадочных маршрутов
		if params[:show_routes] == "true" and params[:with_changes] == "true"
			route_codes = @routes.map(&:route_code)
			change_route_codes = @isochrones.map{|i| i.properties['routes']}.reduce(:concat).uniq.select{|r| !route_codes.include?(r)}
			@change_routes = get_changes_routes(change_route_codes, params[:city_id])
		else
			@change_routes = []
		end

		# Получаем список метрик изохронов
		@metrics = get_metrics(@isochrones.map(&:id))
	end


	private
	# Список изохронов
	def get_isochrones(params)
			
		# Получаем список изохронов
		isochrones = Isochrone.where(profile: params[:profile], city_id: params[:city_id])
		isochrones = isochrones.where(source_station_id: params[:station_id]) if params[:station_id].present?
		isochrones = isochrones.where(with_interval: params[:with_interval]) if params[:with_interval].present?
		isochrones = isochrones.where(with_changes: params[:with_changes]) if params[:with_changes].present?
		isochrones = isochrones.where(contour: params[:contour]) if params[:contour].present?
		isochrones = isochrones.sort_by{|i| -i['contour']}

		return isochrones
	end

	# Список маршрутов, проходящих через остановку
	def get_routes(params)
		routes = []
		routes = Station.find_by(source_id: params[:station_id], city_id: params[:city_id]).routes

		return routes
	end

	# Список маршрутов с учётом пересадок
	def get_changes_routes(route_codes, city_id)
		routes = Route.where(route_code: route_codes, city_id: city_id)
	end

	# Список метрик изохронов
	def get_metrics(isochrone_ids)
		metrics = Metric.where(isochrone_id: isochrone_ids)
			.joins(:metric_type)
			.joins(:isochrone)
			.select("metric_types.metric_code, metric_types.metric_name, isochrones.contour, metrics.isochrone_unique_code, metrics.metric_value")

		results = []
		
		metrics.map(&:metric_name).uniq.each do |code|
			result = {name: code}
			values = metrics.filter{|m| m.metric_name == code}.map{|m| "\"#{m.contour}\": #{m.metric_value}"}.join(', ')
			result['metrics'] = JSON.parse("{#{values}}")
			results.push(result)
		end

		return results
	end

end
