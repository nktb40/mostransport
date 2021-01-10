class CreateHouses < ActiveRecord::Migration[5.2]
  def change
    create_table :houses do |t|
    	t.integer "city_id"
    	t.integer "source_id"
    	t.text "street_name"
    	t.string "house_number"
    	t.string "building"
    	t.string "block"
    	t.string "letter"
    	t.text "address"
    	t.integer "floor_count_min"
    	t.integer "floor_count_max"
    	t.integer "entrance_count" 
    	t.float "area_total"
    	t.float "area_residential"
    	t.integer "population"
    	t.json "geometry"
    	t.boolean "far_from_stops_flag"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end

    remove_column :cities, :tile_stations_url, :string
    remove_column :cities, :tile_routes_url, :string
    remove_column :cities, :tile_density_url, :string
    add_column :cities, :region_name, :string
    add_index :cities, :code, unique: true

    add_index :houses, [:city_id,:source_id], unique: true

    add_index :routes, [:city_id,:source_id], unique: true

    add_index :layers, [:city_id,:layer_type_id], unique: true

    add_column :lnk_station_routes, :route_time, :float
    add_column :lnk_station_routes, :distance, :float
  end
end
