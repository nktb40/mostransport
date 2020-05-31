class CreateMetrics < ActiveRecord::Migration[5.2]
  def change
    create_table :metric_types do |t|
    	t.string "metric_code"
    	t.string "metric_name"
    	t.string "unit_code"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end

    create_table :metrics do |t|
    	t.integer "metric_type_id"
    	t.integer "isochrone_id"
    	t.string "isochrone_unique_code"
    	t.integer "metric_value"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end
  end
end
