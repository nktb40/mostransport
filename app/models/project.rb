class Project < ActiveRecord::Base
	belongs_to :city, required: false
	belongs_to :user

	has_many :lnk_project_routes
	has_many :routes, :through => :lnk_project_routes

	has_many :lnk_project_stations
	has_many :stations, :through => :lnk_project_stations
end