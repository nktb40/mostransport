class AddTileRouteUrlToCity < ActiveRecord::Migration[5.2]
  def change
  	add_column :cities, :tile_routes_url, :string
  	rename_column :cities, :tile_url, :tile_stations_url
  end
end
