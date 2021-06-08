class ConstructorController < ApplicationController
	def index
		if params[:city].present?
			@default_city = params[:city]
		elsif params[:project_id].present?
			if user_signed_in? and current_user.projects.ids.include?(params[:project_id].to_i)
				@default_project = params[:project_id].to_i
			else
				redirect_to :action => "index"
			end
		else
			@default_city = 'MSK'
		end
	end

	def get_layers
		@layers = Layer.where(city_id: params[:city_id])
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
			"desc":"Площадь покрытия остановками",
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
			"desc":"Доля населения в зоне покрытия",
			"data":[
				{"id":1,"name":"Население в зоне покрытия","unit":" "+cp['unit_code'],"quantity":cp['metric_value'],"percentage":cps['metric_value']},
				{"id":2,"name":"Население вне зоны покрытия","unit":" "+cp['unit_code'],"quantity":(cp['metric_value']/cps['metric_value']*100-cp['metric_value']).round(2),"percentage":(100 - cps['metric_value']).round(2)}
			]
		}
		@chartData.append(popChart)

		# Добавляем данные для чарта по домам
		ch = @city_metrics.find{|m| m['metric_code'] == "cover_houses"}
		chs = @city_metrics.find{|m| m['metric_code'] == "cover_houses_share"}
		if ch.present?
			housesChart = {
				"name":"houses-chart",
				"desc":"Доля домов в зоне покрытия",
				"data":[
					{"id":1,"name":"Дома в зоне покрытия","unit":" "+ch['unit_code'],"quantity":ch['metric_value'],"percentage":chs['metric_value']},
					{"id":2,"name":"Дома вне зоны покрытия","unit":" "+ch['unit_code'],"quantity":(ch['metric_value']/chs['metric_value']*100-ch['metric_value']).round(2),"percentage":(100 - chs['metric_value']).round(2)}
				]
			}
			@chartData.append(housesChart)
		end

		@city_metrics = @city_metrics.filter{|m| ['work_places_share','university_places_share','schoolkids_places_share','preschool_places_share','universities_population_share','schoolkids_population_share','preschool_population_share','offices_population_share','stations_per_100k','routes_per_100k','cover_area_share','cover_population_share','cover_houses_share'].include?(m['metric_code'])}

	end

end
