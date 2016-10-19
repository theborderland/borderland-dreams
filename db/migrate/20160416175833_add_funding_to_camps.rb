class AddFundingToCamps < ActiveRecord::Migration
  def change
    add_column :camps, :minfunded, :boolean, { :default => false }
    add_column :camps, :fullyfunded, :boolean, { :default => false }
  end
end
