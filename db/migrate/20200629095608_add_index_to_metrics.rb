class AddIndexToMetrics < ActiveRecord::Migration[5.2]
  def change
  	add_index :metrics, [:metric_type_id, :isochrone_id], unique: true
  	add_index :isochrones, :profile, unique: false
  	add_index :isochrones, :contour, unique: false
  end
end
