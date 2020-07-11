class ChangeStations < ActiveRecord::Migration[5.2]
  def up
  	change_column :stations, :source_id, :string
  	change_column :stations, :route_numbers, 'json USING CAST(route_numbers AS json)'
  	rename_column :stations, :route_numbers, :route_ids
  	remove_column :stations, :name
  end

  def down
  	change_column :stations, :source_id, 'integer USING CAST(source_id AS integer)'
  	rename_column :stations, :route_ids, :route_numbers
  	change_column :stations, :route_numbers, :string
  	add_column :stations, :name, :string
  end
end
