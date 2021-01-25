class CreateAccident < ActiveRecord::Migration[5.2]
  def change
    create_table :accidents do |t|
    	t.integer "city_id"
    	t.integer "source_id"
		t.integer "light_id"
		t.integer "region_id"
		t.text "address"
		t.integer "category_id"
		t.datetime "datetime"
		t.integer "dead_count"
		t.integer "injured_count"
		t.integer "participants_count"
		t.integer "severity_id"
		t.json "geometry"
		t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end

    create_table :accident_tags do |t|
    	t.string "name"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end

    create_table :lnk_accident2tags do |t|
    	t.integer "accident_id"
    	t.integer "tag_id"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end

    create_table :accident_lights do |t|
    	t.string "name"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
	end

	create_table :accident_nearbies do |t|
    	t.string "name"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
	end

	create_table :lnk_accident2nearbies do |t|
    	t.integer "accident_id"
    	t.integer "nearby_id"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end

    create_table :accident_weathers do |t|
    	t.string "name"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
	end

	create_table :lnk_accident2weather do |t|
    	t.integer "accident_id"
    	t.integer "weather_id"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end

    create_table :accident_categories do |t|
    	t.string "name"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
	end

	create_table :accident_severities do |t|
    	t.string "name"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
	end

	create_table :accident_regions do |t|
    	t.string "name"
    	t.integer "parent_id"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
	end

	create_table :road_conditions do |t|
    	t.string "name"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
	end

	create_table :lnk_accident2road_conditions do |t|
    	t.integer "accident_id"
    	t.integer "road_condition_id"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end

    create_table :participant_categories do |t|
    	t.string "name"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
	end

	create_table :lnk_accident2participant_categories do |t|
    	t.integer "accident_id"
    	t.integer "participant_category_id"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end

    create_table :vehicle do |t|
    	t.string "year"
    	t.string "brand"
    	t.string "model"
    	t.string "color"
    	t.string "category"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
	end

	create_table :lnk_accident2vehicles do |t|
    	t.integer "accident_id"
    	t.integer "vehicle_id"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end

    create_table :participants do |t|
    	t.string "role"
    	t.string "gender"
    	t.integer "health_status_id"
    	t.integer "years_of_driving_experience"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
	end

	create_table :health_statuses do |t|
    	t.string "name"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
	end

	create_table :lnk_vehicle2participants do |t|
    	t.integer "vehicle_id"
    	t.integer "participant_id"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end

    create_table :lnk_accident2participants do |t|
    	t.integer "accident_id"
    	t.integer "participant_id"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end

    create_table :violations do |t|
    	t.string "name"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
	end

	create_table :lnk_participant2violations do |t|
    	t.integer "participant_id"
    	t.integer "violation_id"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end

  end
end
