class AddScholarshipFieldsToDreamProp < ActiveRecord::Migration
  def change
    add_column :camps, :dreamscholarship_fund_is_from_art_fund, :boolean, null: false, default: false
    add_column :camps, :dreamscholarship_fund_is_open_for_public, :boolean, null: false, default: false
    add_column :camps, :dreamscholarship_budget_min_original, :integer, { :default => 0 }
    add_column :camps, :dreamscholarship_budget_max_original, :integer, { :default => 0 }
    add_column :camps, :dreamscholarship_budget_max_original_desc, :string, :limit => 4096
    add_column :camps, :dreamscholarship_bank_account_info, :string, :limit => 128
    add_column :camps, :dreamscholarship_financial_conduct_is_intial_budget, :boolean, null: false, default: false
    add_column :camps, :dreamscholarship_financial_conduct_intial_budget_desc, :string, :limit => 4096
    add_column :camps, :dreamscholarship_financial_conduct_money_raise_desc, :string, :limit => 4096
    add_column :camps, :dreamscholarship_execution_potential_previous_experience, :string, :limit => 4096
    add_column :camps, :dreamscholarship_execution_potential_work_plan, :string, :limit => 4096
  end
end
