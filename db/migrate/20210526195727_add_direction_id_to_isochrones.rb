class AddDirectionIdToIsochrones < ActiveRecord::Migration[5.2]
  def change
  	add_column :isochrones, :direction_id, :integer
  	add_column :isochrones, :source_direction_id, :string
  end
end
