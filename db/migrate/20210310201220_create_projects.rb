class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
    	t.string "name"
    	t.integer "city_id"
        t.integer "user_id"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end

    create_table :lnk_project_routes do |t|
    	t.integer "project_id"
    	t.integer "route_id"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end

    create_table :lnk_project_stations do |t|
    	t.integer "project_id"
    	t.integer "station_id"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end

  end
end
