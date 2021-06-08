class CreateDirections < ActiveRecord::Migration[5.2]
  def change
    create_table :directions do |t|
    	t.string "source_id"
    	t.integer "route_id"
        t.string "name"
    	t.json "bbox"
    	t.json "geo_data"
    	t.boolean "circular_flag"
    	t.boolean "deleted_flag", default: false
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end

    add_index :directions, [:route_id, :source_id], unique: true
    add_index :directions, :route_id, unique: false
    add_index :directions, :source_id, unique: false

    create_table :lnk_direction_stations do |t|
    	t.integer "direction_id"
    	t.integer "station_id"
    	t.integer "seq_no"
    	t.float "route_time"
    	t.float "distance"
    	t.boolean "deleted_flag", default: false
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end

    add_index :lnk_direction_stations, :direction_id, unique: false
    add_index :lnk_direction_stations, :station_id, unique: false
    add_index :lnk_direction_stations, [:direction_id, :station_id, :seq_no], unique: true, name: 'lnk_direction_stations_main_index'

  end
end
