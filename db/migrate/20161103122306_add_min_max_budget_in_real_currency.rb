class AddMinMaxBudgetInRealCurrency < ActiveRecord::Migration
  def change
  	add_column :camps, :minbudget_realcurrency, :integer
    add_column :camps, :maxbudget_realcurrency, :integer
  end
end
