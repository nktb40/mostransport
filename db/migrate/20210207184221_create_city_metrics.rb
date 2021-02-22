class CreateCityMetrics < ActiveRecord::Migration[5.2]
  def change
    create_table :city_metrics do |t|
    	t.integer "metric_type_id"
    	t.integer "city_id"
    	t.float "metric_value"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end

    add_index :city_metrics, [:metric_type_id, :city_id], unique: true
    add_index :city_metrics, :metric_type_id, unique: false
    add_index :city_metrics, :city_id, unique: false

    add_column :cities, :population, :integer
    add_column :cities, :area, :float
  end
end
