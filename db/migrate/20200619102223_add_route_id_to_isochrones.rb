class AddRouteIdToIsochrones < ActiveRecord::Migration[5.2]
  def change
  	add_column :isochrones, :route_id, :integer
  	add_column :isochrones, :source_route_id, :integer
  end
end
