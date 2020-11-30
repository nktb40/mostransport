class AddIndexToStationsAndIsochrones < ActiveRecord::Migration[5.2]
  def change
  	add_index :stations, [:source_id, :city_id], unique: true
  	add_index :isochrones, [:station_id, :contour, :profile], unique: false
  end
end
