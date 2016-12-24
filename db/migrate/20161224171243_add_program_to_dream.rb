class AddProgramToDream < ActiveRecord::Migration
  def change
  	add_column :camps, :program_dream_name_he, :string, :limit => 256
  	add_column :camps, :program_dream_name_en, :string, :limit => 256
    add_column :camps, :program_dreamer_name_he, :string, :limit => 256
    add_column :camps, :program_dreamer_name_en, :string, :limit => 256
    add_column :camps, :program_dream_about_he, :string, :limit => 4096
    add_column :camps, :program_dream_about_en, :string, :limit => 4096
    add_column :camps, :program_special_activity, :string, :limit => 4096
  end
end
