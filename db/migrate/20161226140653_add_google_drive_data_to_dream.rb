class AddGoogleDriveDataToDream < ActiveRecord::Migration
  def change
    add_column :camps, :google_drive_folder_path, :string, :limit => 512
    add_column :camps, :google_drive_gaunt_file_path, :string, :limit => 512
    add_column :camps, :google_drive_budget_file_path, :string, :limit => 512
  end
end
