class CreateRouteMetrics < ActiveRecord::Migration[5.2]
  def change
    create_table :route_metrics do |t|
    	t.integer "metric_type_id"
    	t.integer "route_id"
    	t.float "metric_value"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end

    add_index :route_metrics, [:metric_type_id, :route_id], unique: true
    add_index :route_metrics, :metric_type_id, unique: false
    add_index :route_metrics, :route_id, unique: false
  end
end
