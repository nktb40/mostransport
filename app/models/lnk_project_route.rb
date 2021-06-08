class LnkProjectRoute < ActiveRecord::Base
	belongs_to :project
	belongs_to :route
end