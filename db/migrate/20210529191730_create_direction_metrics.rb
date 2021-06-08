class CreateDirectionMetrics < ActiveRecord::Migration[5.2]
  def change
    create_table :direction_metrics do |t|
    	t.integer "metric_type_id"
    	t.integer "direction_id"
        t.integer "route_id"
    	t.float "metric_value"
    	t.boolean "deleted_flag", default: false
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end

    add_index :direction_metrics, [:metric_type_id, :direction_id], unique: true
    add_index :direction_metrics, :metric_type_id, unique: false
    add_index :direction_metrics, :direction_id, unique: false
    add_index :direction_metrics, :route_id, unique: false
  end
end
