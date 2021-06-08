class LnkProjectStation < ActiveRecord::Base
	belongs_to :project
	belongs_to :station
end