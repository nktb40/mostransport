class CreateCities < ActiveRecord::Migration[5.2]
  def change
    create_table :cities do |t|
    	t.string "name"
    	t.string "code"
    	t.float "latitude"
    	t.float "longitude"
        t.json "bbox"
    	t.datetime "created_at", null: false
		t.datetime "updated_at", null: false
    end
    
    add_column :stations, :city_id, :integer
    add_column :routes, :city_id, :integer
    add_column :isochrones, :city_id, :integer
    
    add_index :stations, :city_id, unique: false
    add_index :routes, :city_id, unique: false
    add_index :isochrones, :city_id, unique: false
  end
end
