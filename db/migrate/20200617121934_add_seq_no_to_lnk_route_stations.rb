class AddSeqNoToLnkRouteStations < ActiveRecord::Migration[5.2]
  def change
  	add_column :lnk_station_routes, :seq_no, :integer
  	add_column :lnk_station_routes, :track_no, :integer
  	add_column :routes, :source_id, :integer
  end
end
