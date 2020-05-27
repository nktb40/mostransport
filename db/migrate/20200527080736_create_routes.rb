class CreateRoutes < ActiveRecord::Migration[5.2]
  def change
    create_table :routes do |t|
    	t.integer "global_id"
    	t.string "route_number"
    	t.string "route_code"
    	t.string "route_name"
    	t.text "track_of_following"
    	t.text "reverse_track_of_following"
    	t.string "type_of_transport"
    	t.string "carrier_name"
    	t.json "geo_data"
    	t.integer "route_interval"
    	t.integer "route_length"
    	t.integer "route_cost"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end
  end
end
