class AddFieldsToDreamProp < ActiveRecord::Migration
  def change
    add_column :camps, :dreamprop_philosophy, :string, :limit => 4096
    add_column :camps, :dreamprop_inspiration, :string, :limit => 4096
    add_column :camps, :dreamprop_interactivity_audience_participation, :string, :limit => 4096
    add_column :camps, :dreamprop_interactivity_is_fire_present, :boolean, null: false, default: false
    add_column :camps, :dreamprop_interactivity_fire_present_desc, :string, :limit => 4096
    add_column :camps, :dreamprop_interactivity_is_sound, :boolean, null: false, default: false
    add_column :camps, :dreamprop_interactivity_sound_desc, :string, :limit => 4096
    add_column :camps, :dreamprop_interactivity_is_fire_event, :boolean, null: false, default: false
    add_column :camps, :dreamprop_interactivity_fire_event_desc, :string, :limit => 4096
    add_column :camps, :dreamprop_community_is_installation_present_for_event, :boolean, null: false, default: false
    add_column :camps, :dreamprop_community_is_installation_present_for_public, :boolean, null: false, default: false
    add_column :camps, :dreamprop_community_is_context, :boolean, null: false, default: false
    add_column :camps, :dreamprop_community_context_desc, :string, :limit => 4096
    add_column :camps, :dreamprop_community_is_interested_in_publicity, :boolean, null: false, default: false
    add_column :camps, :dreamprop_theme_is_annual, :boolean, null: false, default: false
    add_column :camps, :dreamprop_theme_annual_desc, :string, :limit => 4096
  end
end
