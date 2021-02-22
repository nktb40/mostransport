class RouteMetric < ActiveRecord::Base
	belongs_to :metric_type
	belongs_to :route
end