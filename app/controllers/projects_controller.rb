class ProjectsController < ApplicationController
	
	before_action :authenticate_user!
	
	# Форма создания нового проекта
	def new
		@project = Project.new
	end

	# ============ Импорт Остановок ==========

	# Форма импорта остановок в проект
	def get_import_stations_form
		@project = Project.find(params[:id])
	end

	# Импорт всех остановок в проект
	def import_all_stations
		@project = Project.find(params[:project_id])

		not_imported = @project.city.stations.where.not(id: @project.stations.ids)		
		not_imported.each do |station|
			p2s = LnkProjectStation.create(project_id: @project.id, station_id: station.id)
		end

		render :get_import_stations_form
	end	

	# Импорт одной остановки в проект
	def import_station
		@project = Project.find(params[:project_id])
		LnkProjectStation.create(project_id: @project.id, station_id: params[:station_id])

		render :get_import_stations_form
	end	

	# Удаление импортированной остановки из проекта
	def remove_station
		project_id = params[:project_id]
		LnkProjectStation.find_by(project_id: project_id, station_id: params[:station_id]).delete
		@project = Project.find(params[:project_id])

		render :get_import_stations_form
	end

	# Удаление всех импортированных остановок из проекта
	def remove_all_stations
		@project = Project.find(params[:project_id])
		LnkProjectStation.where(project_id: @project.id).delete_all

		render :get_import_stations_form
	end

	# ============ Импорт Маршрутов ==========

	# Форма импорта маршрута в проект
	def get_import_routes_form
		@project = Project.find(params[:id])
	end

	# Импорт всех маршрутов в проект
	def import_all_routes
		@project = Project.find(params[:project_id])

		not_imported = @project.city.routes.where.not(id: @project.routes.ids)		
		not_imported.each do |route|
			p2r = LnkProjectRoute.create(project_id: @project.id, route_id: route.id)
		end

		render :get_import_routes_form
	end	

	# Импорт одного маршрута в проект
	def import_route
		@project = Project.find(params[:project_id])
		LnkProjectRoute.create(project_id: @project.id, route_id: params[:route_id])

		render :get_import_routes_form
	end	

	# Удаление импортированного маршрута из проекта
	def remove_route
		project_id = params[:project_id]
		route_id = params[:route_id]
		LnkProjectRoute.find_by(project_id: project_id, route_id: route_id).delete
		@project = Project.find(params[:project_id])

		render :get_import_routes_form
	end

	# Удаление всех импортированных маршрутов из проекта
	def remove_all_routes
		@project = Project.find(params[:project_id])
		LnkProjectRoute.where(project_id: @project.id).delete_all

		render :get_import_routes_form
	end

	def create
		@project = Project.new(project_params)
		@project.user = current_user
		@project.save
	end

	private

	def project_params
		params.require(:project).permit(:name, :city_id)
	end
end