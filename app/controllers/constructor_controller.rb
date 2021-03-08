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
		@walk_iso = Isochrone.find_by(station_id: @station.id, contour: 5, profile: 'walking')
		@metrics = StationMetric.where(station_id: @station.id).map{|m| {metric_code:m.metric_type.metric_code, metric_name:m.metric_type.metric_name, metric_value:m.metric_value, unit_code:m.metric_type.unit_code}}
		@metrics.concat(Metric.where(isochrone_id: @walk_iso.id).map{|m| {metric_code:m.metric_type.metric_code, metric_name:m.metric_type.metric_name, metric_value:m.metric_value, unit_code:m.metric_type.unit_code}})
		
		generator = ColorGenerator.new saturation: 0.9, lightness: 0.4
		@routes = @station.routes.map{|r| {id:r.id, route_code: r.route_code, geo_data: r.geo_data, color: "#" + generator.create_hex}}
	
		isochrones = []
		iso = Isochrone.find_by(station_id: @station.id, contour: 5, profile: 'walking')
		isochrones.append({type:"Feature", properties:{profile:iso.profile}, geometry:iso.geo_data})
		iso = Isochrone.find_by(station_id:@station.id, contour:30, profile: 'public_transport', with_interval: true, with_changes: false)
		isochrones.append({type:"Feature", properties:{profile:iso.profile}, geometry:iso.geo_data})
		iso = Isochrone.find_by(station_id:@station.id, contour:30, profile: 'public_transport', with_interval: true, with_changes: true)
		isochrones.append({type:"Feature", properties:{profile:iso.profile+"_chng"}, geometry:iso.geo_data})
		
		@isochrones_collection = {type:"FeatureCollection", features:isochrones}
	end

	def get_city_metrics
		@city = City.find(params[:selected_city_id])
		@city_metrics = @city.city_metrics.joins(:metric_type).select("metric_types.metric_code, metric_types.metric_name, city_metrics.metric_type_id, city_metrics.metric_value, metric_types.unit_code")

		@chartData = []

		# Добавляем данные для чарта по площади покрытия
		ca = @city_metrics.find{|m| m['metric_code'] == "cover_area"}
		cas = @city_metrics.find{|m| m['metric_code'] == "cover_area_share"}
		areaChart = {
			"name":"area-chart",
			"data":[
				{"id":1,"name":"Покрываемая площадь","unit":" "+ca['unit_code'],"quantity":ca['metric_value'],"percentage":cas['metric_value']},
				{"id":2,"name":"Непокрываемая площадь","unit":" "+ca['unit_code'],"quantity":(@city.area - ca['metric_value']).round(2),"percentage":(100 - cas['metric_value']).round(2)}
			]
		}
		@chartData.append(areaChart)

		# Добавляем данные для чарта по населению
		cp = @city_metrics.find{|m| m['metric_code'] == "cover_population"}
		cps = @city_metrics.find{|m| m['metric_code'] == "cover_population_share"}
		popChart = {
			"name":"population-chart",
			"data":[
				{"id":1,"name":"Население в зоне покрытия","unit":" "+cp['unit_code'],"quantity":cp['metric_value'],"percentage":cps['metric_value']},
				{"id":2,"name":"Население вне зоны покрытия","unit":" "+cp['unit_code'],"quantity":(cp['metric_value']/cps['metric_value']*100-cp['metric_value']).round(2),"percentage":(100 - cps['metric_value']).round(2)}
			]
		}
		@chartData.append(popChart)

		# Добавляем данные для чарта по домам
		ch = @city_metrics.find{|m| m['metric_code'] == "cover_houses"}
		chs = @city_metrics.find{|m| m['metric_code'] == "cover_houses_share"}
		housesChart = {
			"name":"houses-chart",
			"data":[
				{"id":1,"name":"Дома в зоне покрытия","unit":" "+ch['unit_code'],"quantity":ch['metric_value'],"percentage":chs['metric_value']},
				{"id":2,"name":"Дома вне зоны покрытия","unit":" "+ch['unit_code'],"quantity":(ch['metric_value']/chs['metric_value']*100-ch['metric_value']).round(2),"percentage":(100 - chs['metric_value']).round(2)}
			]
		}
		@chartData.append(housesChart)

		@city_metrics = @city_metrics.filter{|m| ['stations_per_100k','routes_per_100k','cover_area_share','cover_population_share','cover_houses_share'].include?(m['metric_code'])}

	end

end