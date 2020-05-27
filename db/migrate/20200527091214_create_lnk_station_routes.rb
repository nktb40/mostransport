class CreateLnkStationRoutes < ActiveRecord::Migration[5.2]
  def change
    create_table :lnk_station_routes do |t|
    	t.integer "station_id"
    	t.integer "route_id"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end
  end
end
