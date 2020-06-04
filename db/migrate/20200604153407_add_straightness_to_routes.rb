class AddStraightnessToRoutes < ActiveRecord::Migration[5.2]
  def change
  	add_column :routes, :straightness, :float
  	change_column :routes, :route_interval, :float
  	change_column :routes, :route_length, :float
  	change_column :routes, :route_cost, :float
  end
end
