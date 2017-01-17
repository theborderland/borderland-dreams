class AddEnglishNameAndDescToCamp < ActiveRecord::Migration
  def change
    add_column :camps, :en_name, :string, :limit => 64
    add_column :camps, :en_subtitle, :string, :limit => 255
  end
end
