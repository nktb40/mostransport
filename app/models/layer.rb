class Layer < ActiveRecord::Base
	belongs_to :city
	belongs_to :layer_type
end