class Metric < ActiveRecord::Base
	belongs_to :metric_type
	belongs_to :isochrone
end