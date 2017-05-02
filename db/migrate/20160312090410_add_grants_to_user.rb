class AddGrantsToUser < ActiveRecord::Migration
  def change
    change_column :users, :grants, :integer, { :default => 8 }
  end
end