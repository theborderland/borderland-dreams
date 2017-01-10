class RemoveGauntFromGoogleAppsScript < ActiveRecord::Migration
  def change
    remove_column :camps, :google_drive_gaunt_file_path, :string
  end
end
