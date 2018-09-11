class AddGrantApplicationDetailsToCamp < ActiveRecord::Migration
  def change
    add_column :camps, :ga_costumes, :boolean, { default: false }
    add_column :camps, :ga_consumables, :boolean, { default: false }
    add_column :camps, :ga_intoxicants, :boolean, { default: false }
    add_column :camps, :ga_valuable_equipment, :boolean, { default: false }
    add_column :camps, :ga_transport, :boolean, { default: false }
    add_column :camps, :ga_vehicle_costs, :boolean, { default: false }
    add_column :camps, :ga_sound_equipment, :boolean, { default: false }
    add_column :camps, :ga_explanation, :text, { limit: 4096 }
  end
end
