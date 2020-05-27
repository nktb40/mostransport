class CreateStations < ActiveRecord::Migration[5.2]
  def change
    create_table :stations do |t|
    	t.integer "source_id"
    	t.string "name"
    	t.float "latitude"
    	t.float "longitude"
    	t.text "route_numbers"
    	t.string "station_name"
    	t.json "geo_data"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end
  end
end