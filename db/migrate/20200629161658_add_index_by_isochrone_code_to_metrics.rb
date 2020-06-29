class AddIndexByIsochroneCodeToMetrics < ActiveRecord::Migration[5.2]
  def change
  	add_index :metrics, :isochrone_unique_code, unique: false
  end
end
