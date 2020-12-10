class AddIndexToMetricsRoutes < ActiveRecord::Migration[5.2]
  def change
  	add_index :isochrones, [:route_id, :profile, :contour], unique: false
  	add_index :metrics, [:isochrone_id], unique: false
  end
end
