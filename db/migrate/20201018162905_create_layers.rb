class CreateLayers < ActiveRecord::Migration[5.2]
  def change
    create_table :layers do |t|
    	t.integer "layer_type_id"
    	t.string "tile_url"
    	t.integer "city_id"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end

    create_table :layer_types do |t|
    	t.string "name"
    	t.string "code"
        t.string "source_name"
        t.string "draw_type"
        t.json "paint_rule"
        t.boolean "default"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end
  end
end
