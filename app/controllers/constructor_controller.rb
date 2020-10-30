class ConstructorController < ApplicationController
	def get_layers
		@layers = Layer.where(city_id: params[:city_id])
	end	
end