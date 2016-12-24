class AddLocationToDream < ActiveRecord::Migration
  def change
    add_column :camps, :location_info, :string, :limit => 1024
  end
end