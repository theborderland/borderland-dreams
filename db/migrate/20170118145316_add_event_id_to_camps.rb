class AddEventIdToCamps < ActiveRecord::Migration
  def change
    add_column :camps, :event_id, :string, :limit => 128, default: Rails.application.config.default_event
  end
end
