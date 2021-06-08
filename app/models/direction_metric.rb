class DirectionMetric < ActiveRecord::Base
	belongs_to :metric_type
	belongs_to :direction
	belongs_to :route
end