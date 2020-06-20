class AddIndexToIsochrones < ActiveRecord::Migration[5.2]
  def change
  	add_index :isochrones, :unique_code, unique: true
  end
end
