class ChangeRoutes < ActiveRecord::Migration[5.2]
  def up
  	remove_column :routes, :global_id
  	remove_column :routes, :track_of_following
  	remove_column :routes, :reverse_track_of_following
  	remove_column :routes, :carrier_name

  	add_column :routes, :circular_flag, :boolean

  	change_column :routes, :source_id, :string
  end

  def down
  	add_column :routes, :global_id, :integer
  	add_column :routes, :track_of_following, :text
  	add_column :routes, :reverse_track_of_following, :text
  	add_column :routes, :carrier_name, :string

  	remove_column :routes, :circular_flag

  	change_column :routes, :source_id, 'integer USING CAST(source_id AS integer)'
  end
end
