class AddIndexToLnkStationRoute < ActiveRecord::Migration[5.2]
  def change
  	add_index :lnk_station_routes, [:station_id, :route_id, :track_no], unique: true, name: 'lnk_station_routes_main_index'
  	add_index :lnk_station_routes, :station_id, unique: false
  	add_index :lnk_station_routes, :route_id, unique: false
  end
end
