class AddDeletedFalg < ActiveRecord::Migration[5.2]
  def change
  	add_column :cities, :deleted_flag, :boolean, :default => false
  	add_column :stations, :deleted_flag, :boolean, :default => false
  	add_column :routes, :deleted_flag, :boolean, :default => false
  	add_column :isochrones, :deleted_flag, :boolean, :default => false
  	add_column :metrics, :deleted_flag, :boolean, :default => false
  	add_column :city_metrics, :deleted_flag, :boolean, :default => false
  	add_column :station_metrics, :deleted_flag, :boolean, :default => false
  	add_column :route_metrics, :deleted_flag, :boolean, :default => false
  	add_column :lnk_station_routes, :deleted_flag, :boolean, :default => false
  	add_column :houses, :deleted_flag, :boolean, :default => false
  end
end
