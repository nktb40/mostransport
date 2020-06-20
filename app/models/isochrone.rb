class Isochrone < ActiveRecord::Base
	belongs_to :station, required: false
	belongs_to :route, required: false
	has_many :metrics
end