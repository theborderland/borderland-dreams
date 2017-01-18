class AddMoreFieldsToCampProjectMgmt < ActiveRecord::Migration
  def change
    add_column :camps, :projectmgmt_is_theme_camp_dream, :boolean, null: false, default: false
    add_column :camps, :projectmgmt_is_dream_near_theme_camp, :boolean, null: false, default: false
    add_column :camps, :projectmgmt_dream_pre_construction_site, :string, :limit => 4096
  end
end
