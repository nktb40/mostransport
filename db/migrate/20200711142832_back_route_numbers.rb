class BackRouteNumbers < ActiveRecord::Migration[5.2]
  def up
  	rename_column :stations, :route_ids, :route_numbers
  	change_column :stations, :route_numbers, :string
  end

  def down
  	change_column :stations, :route_numbers, 'json USING CAST(route_numbers AS json)'
  	rename_column :stations, :route_numbers, :route_ids
  end
end
