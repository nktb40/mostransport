class CreateIsochrones < ActiveRecord::Migration[5.2]
  def change
    create_table :isochrones do |t|
        t.integer "station_id"
    	t.string "unique_code"
    	t.integer "source_station_id"
    	t.integer "contour"
    	t.string "profile"
    	t.boolean "with_interval"
    	t.json "geo_data"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end
  end
end
