class StationMetric < ActiveRecord::Base
	belongs_to :metric_type
	belongs_to :station
end