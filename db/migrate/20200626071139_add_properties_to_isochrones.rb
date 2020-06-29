class AddPropertiesToIsochrones < ActiveRecord::Migration[5.2]
  def change
  	add_column :isochrones, :properties, :json
  end
end
