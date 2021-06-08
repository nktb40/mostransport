class RoutesController < ApplicationController
	
	before_action :authenticate_user!, only: [:edit]

	def show
		@route = Route.find(params[:route_id])
		@directions = @route.directions
		
		if params[:direction_id].present?
			@direction = Direction.find(params[:direction_id])
		else
			@direction = @directions.first
		end			

		@stations = LnkDirectionStation.joins(:station).where(direction_id: @direction.id)
					.select("station_id, source_id, stations.station_name, stations.source_id, direction_id, seq_no, route_time, distance").sort_by(&:seq_no)

		isochrones = Isochrone.where(direction_id: @direction.id, profile: "direction_cover", contour: 5)
		@isochrones = isochrones.map(&:geo_data)

		@isochrone_metrics = isochrones.joins(:metrics).joins('INNER JOIN metric_types ON metrics.metric_type_id = metric_types.id').select('route_id, metric_value, metric_name, metric_types.unit_code')
		
		@route_metrics = @route.route_metrics.joins(:metric_type).select("metric_types.metric_code, metric_types.metric_name, route_metrics.metric_value, metric_types.unit_code")


		subquery = Direction.find(@direction.id).duplications.select("direction_id, dupl_direction_id, dupl_route_id, distance, value, row_number() over(partition by direction_id, dupl_route_id order by value desc) rn").where(deleted_flag: false)
		@duplications = Direction.unscoped.select("s.direction_id, s.dupl_direction_id, s.dupl_route_id, r.route_code, s.distance, s.value").from(subquery,:s).joins("INNER JOIN routes r ON r.id = s.dupl_route_id and r.deleted_flag = False")
						.where("rn=1 and s.value >= 8")
						.order("s.value desc")

		@duplicated_sections = Section.where(deleted_flag: false)
								.joins("INNER JOIN lnk_direction_sections l1 ON l1.direction_id = #{@direction.id} and l1.deleted_flag = False and sections.id = l1.section_id")
								.joins("INNER JOIN lnk_direction_sections l2 ON l2.direction_id in (#{@duplications.map(&:dupl_direction_id).join(",")}) and l2.deleted_flag = False and l1.section_id = l2.section_id")	
								.select("l1.direction_id, l2.direction_id as dupl_direction_id, sections.geometry")					
	end

	def get_city_routes
		if params[:city_id].present?
			@routes = Route.where(city_id: params[:city_id]).order(:route_code)
		elsif params[:project_id].present?
			@routes = Project.find(params[:project_id]).routes.order(:route_code)
		end
		@metrics = DirectionMetric.where(route_id: @routes.ids).joins(:metric_type).where(metric_types:{metric_code: ['route_length','straightness','route_cost']}).select("direction_metrics.direction_id, direction_metrics.route_id, metric_types.metric_code, metric_types.metric_name, direction_metrics.metric_value, metric_types.unit_code")
	end

	def get_route_line
		@route = Route.find(params[:id])
	end

	def edit
		@route = Route.find(params[:id])
		@stations = LnkStationRoute.joins(:station).where(route_id: @route.id)
					.select("station_id, stations.station_name, stations.source_id, route_id, track_no, seq_no, route_time, distance")
	end
end