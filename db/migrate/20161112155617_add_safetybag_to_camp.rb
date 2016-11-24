class AddSafetybagToCamp < ActiveRecord::Migration
  def change
    add_column :camps, :safetybag_crewsize, :integer
    add_column :camps, :safetybag_plan, :string, :limit => 4096
    add_column :camps, :safetybag_builder, :string, :limit => 64
    add_column :camps, :safetybag_safetyer, :string, :limit => 64
    add_column :camps, :safetybag_mooper, :string, :limit => 64
    add_column :camps, :safetybag_materials, :string, :limit => 4096
    add_column :camps, :safetybag_work_in_height, :string, :limit => 4096
    add_column :camps, :safetybag_tools, :string, :limit => 4096
    add_column :camps, :safetybag_grounding, :string, :limit => 4096
    add_column :camps, :safetybag_safety, :string, :limit => 4096
    add_column :camps, :safetybag_electricity, :string, :limit => 4096
    add_column :camps, :safetybag_daily_routine, :string, :limit => 4096
    add_column :camps, :safetybag_other_comments, :string, :limit => 4096
  end
end
