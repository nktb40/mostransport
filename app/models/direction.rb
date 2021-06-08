class Direction < ActiveRecord::Base
	has_many :lnk_direction_stations
	has_many :stations, through: :lnk_direction_stations

	has_many :lnk_direction_sections
	has_many :sections, through: :lnk_direction_sections

	has_many :duplications

	belongs_to :route
end