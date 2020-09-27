class AddDensityUrlToCity < ActiveRecord::Migration[5.2]
  def change
  	add_column :cities, :tile_density_url, :string
  end
end
