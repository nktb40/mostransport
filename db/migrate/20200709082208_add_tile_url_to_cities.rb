class AddTileUrlToCities < ActiveRecord::Migration[5.2]
  def change
  	add_column :cities, :tile_url, :string
  end
end
