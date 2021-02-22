class CityMetric < ActiveRecord::Base
	belongs_to :metric_type
	belongs_to :city
end