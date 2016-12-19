class AddFieldsToDreamProp < ActiveRecord::Migration
  def change
    add_column :camps, :dreamprop_philosophy, :string
    add_column :camps, :dreamprop_inspiration, :string
    add_column :camps, :dreamprop_interactivity_audience_participation, :string
    add_column :camps, :dreamprop_interactivity_is_fire_present, :boolean
    add_column :camps, :dreamprop_interactivity_fire_present_desc, :string
    add_column :camps, :dreamprop_interactivity_is_sound, :boolean
    add_column :camps, :dreamprop_interactivity_sound_desc, :string
    add_column :camps, :dreamprop_interactivity_is_fire_event, :boolean
    add_column :camps, :dreamprop_interactivity_fire_event_desc, :string
    add_column :camps, :dreamprop_community_is_installation_present_for_event, :boolean
    add_column :camps, :dreamprop_community_is_installation_present_for_public, :boolean
    add_column :camps, :dreamprop_community_is_context, :boolean
    add_column :camps, :dreamprop_community_context_desc, :string
    add_column :camps, :dreamprop_community_is_interested_in_publicity, :boolean
    add_column :camps, :dreamprop_theme_is_annual, :boolean
    add_column :camps, :dreamprop_theme_annual_desc, :string
  end
end
