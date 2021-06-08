class Route < ActiveRecord::Base
	has_many :isochrones
	has_many :route_metrics
	has_many :lnk_station_routes
	has_many :stations, through: :lnk_station_routes
	has_many :directions

	belongs_to :city
end