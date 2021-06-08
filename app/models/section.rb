class Section < ActiveRecord::Base
	has_many :lnk_direction_sections
	has_many :directions, through: :lnk_direction_sections

	belongs_to :begin_station, class_name: 'Sation', :foreign_key => 'begin_station_id'
	belongs_to :end_station, class_name: 'Station', :foreign_key => 'end_station_id'
end