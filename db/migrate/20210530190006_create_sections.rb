class CreateSections < ActiveRecord::Migration[5.2]
  def change
    create_table :sections do |t|
    	t.integer "begin_station_id"
    	t.integer "end_station_id"
    	t.float "distance"
    	t.json "bbox"
    	t.json "geometry"
    	t.boolean "deleted_flag", default: false
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end

    add_index :sections, [:begin_station_id, :end_station_id], unique: true
    add_index :sections, :begin_station_id, unique: false
    add_index :sections, :end_station_id, unique: false

    create_table :lnk_direction_sections do |t|
    	t.integer "direction_id"
    	t.integer "section_id"
    	t.boolean "deleted_flag", default: false
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end

    add_index :lnk_direction_sections, [:direction_id, :section_id], unique: true
    add_index :lnk_direction_sections, :direction_id, unique: false
    add_index :lnk_direction_sections, :section_id, unique: false

    create_table :duplications do |t|
    	t.integer "direction_id"
    	t.integer "dupl_direction_id"
    	t.integer "dupl_route_id"
    	t.float "distance"
    	t.float "value"
    	t.boolean "deleted_flag", default: false
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end

    add_index :duplications, [:direction_id, :dupl_direction_id, :dupl_route_id], unique: true, name: 'duplications_main_index'
    add_index :duplications, :direction_id, unique: false
    add_index :duplications, :dupl_direction_id, unique: false
    add_index :duplications, :dupl_route_id, unique: false

  end
end
