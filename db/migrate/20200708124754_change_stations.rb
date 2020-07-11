class ChangeStations < ActiveRecord::Migration[5.2]
  def up
  	change_column :stations, :source_id, :string
  	remove_column :stations, :name
  end

  def down
  	change_column :stations, :source_id, 'integer USING CAST(source_id AS integer)'
  	add_column :stations, :name, :string
  end
end
