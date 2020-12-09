class AddIndexToRoutes < ActiveRecord::Migration[5.2]
  def change
  	add_index :routes, [:route_code, :city_id], unique: false
  end
end
