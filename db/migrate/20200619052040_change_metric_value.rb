class ChangeMetricValue < ActiveRecord::Migration[5.2]
  def change
  	change_column :metrics, :metric_value, :float
  end
end
