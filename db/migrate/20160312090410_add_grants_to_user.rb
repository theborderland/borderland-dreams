class AddGrantsToUser < ActiveRecord::Migration
  def change
    add_column :users, :grants, :integer, { :default => 8 }
  end
end