class AddMinMaxToBudgetItems < ActiveRecord::Migration[5.0]
  def change
    add_column :budget_items, :min_budget, :integer
    add_column :budget_items, :max_budget, :integer
  end
end
