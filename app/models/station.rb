class Station < ActiveRecord::Base
	has_many :isochrones
	has_many :lnk_direction_stations
	has_many :directions, through: :lnk_direction_stations
	has_many :metrics

	belongs_to :city
end