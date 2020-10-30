class City < ActiveRecord::Base
	has_many :routes
	has_many :stations
	has_many :layers
end