class City < ActiveRecord::Base
	has_many :routes
	has_many :stations
end