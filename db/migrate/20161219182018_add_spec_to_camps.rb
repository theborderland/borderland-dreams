class AddSpecToCamps < ActiveRecord::Migration
  def change
    add_column :camps, :spec_physical_description, :string, :limit => 4096
    add_column :camps, :spec_length, :string, :limit => 128
    add_column :camps, :spec_width, :string, :limit => 128
    add_column :camps, :spec_height, :string, :limit => 128
    add_column :camps, :spec_visual_night_day, :string, :limit => 4096
    add_column :camps, :spec_is_electricity, :boolean, null: false, default: false
    add_column :camps, :spec_electricity_details, :string, :limit => 4096
    add_column :camps, :spec_electricity_how, :string, :limit => 4096
    add_column :camps, :spec_electricity_is_daytime, :boolean, null: false, default: false
    add_column :camps, :spec_electricity_watt, :string, :limit => 512
  end
end
