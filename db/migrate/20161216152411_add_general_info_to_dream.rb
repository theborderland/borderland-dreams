class AddGeneralInfoToDream < ActiveRecord::Migration
  def change
  	add_column :camps, :about_the_artist, :string, :limit => 1024
  	add_column :camps, :website, :string, :limit => 512
  end
end
