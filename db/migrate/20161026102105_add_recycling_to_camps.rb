class AddRecyclingToCamps < ActiveRecord::Migration
  def change
  	add_column :camps, :recycling, :text, :limit => 512
  end
end
