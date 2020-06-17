class AddBboxToRoutes < ActiveRecord::Migration[5.2]
  def change
  	add_column :routes, :bbox, :json
  end
end
