class Duplication < ActiveRecord::Base
	belongs_to :direction
	belongs_to :dupl_direction, class_name: 'Direction', :foreign_key => 'dupl_direction_id'
	belongs_to :dupl_route, class_name: 'Route', :foreign_key => 'dupl_route_id'
end