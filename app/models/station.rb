class Station < ActiveRecord::Base
	has_many :isochrones
	has_many :lnk_station_routes
	has_many :routes, through: :lnk_station_routes

	belongs_to :city
end