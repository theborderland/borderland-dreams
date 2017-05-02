class AddDefaultGrantsToUser < ActiveRecord::Migration
  def change
    change_column :users, :grants, :integer, { :default => 10 }
  end
end