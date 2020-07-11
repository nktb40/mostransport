class ChangeLnkRouteStations < ActiveRecord::Migration[5.2]
  def up
  	add_column :lnk_station_routes, :route_type, :string
  	change_column :isochrones, :source_station_id, :string
  	change_column :isochrones, :source_route_id, :string
  end

  def down
  	remove_column :lnk_station_routes, :route_type
  	change_column :isochrones, :source_station_id, 'integer USING CAST(source_station_id AS integer)'
  	change_column :isochrones, :source_route_id, 'integer USING CAST(source_route_id AS integer)'
  end
end
