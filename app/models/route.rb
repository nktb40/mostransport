class Route < ActiveRecord::Base
	has_many :lnk_station_routes
	has_many :stations, through: :lnk_station_routes
end