class Isochrone < ActiveRecord::Base
	belongs_to :station
	has_many :metrics
end