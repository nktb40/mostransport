class CreateStationMetrics < ActiveRecord::Migration[5.2]
  def change
    create_table :station_metrics do |t|
    	t.integer "metric_type_id"
    	t.integer "station_id"
    	t.float "metric_value"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end
    
    add_index :station_metrics, [:metric_type_id, :station_id], unique: true
    add_index :station_metrics, :metric_type_id, unique: false
    add_index :station_metrics, :station_id, unique: false
  end
end
