class LnkDirectionStation < ActiveRecord::Base
	belongs_to :station
	belongs_to :direction
end