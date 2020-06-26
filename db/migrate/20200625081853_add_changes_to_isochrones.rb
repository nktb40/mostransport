class AddChangesToIsochrones < ActiveRecord::Migration[5.2]
  def change
  	add_column :isochrones, :with_changes, :boolean
  end
end
