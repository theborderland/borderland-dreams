class AddSafetyFileToDream < ActiveRecord::Migration
  def change
    add_column :camps, :safety_is_heavy_equipment, :boolean, null: false, default: false
    add_column :camps, :safety_equipment, :string, :limit => 4096
    add_column :camps, :safety_how_to_build_safety, :string, :limit => 4096
    add_column :camps, :safety_how, :string, :limit => 4096
    add_column :camps, :safety_grounding, :string, :limit => 4096
    add_column :camps, :safety_securing, :string, :limit => 4096
    add_column :camps, :safety_securing_parts, :string, :limit => 4096
    add_column :camps, :safety_signs, :string, :limit => 4096
end

end
