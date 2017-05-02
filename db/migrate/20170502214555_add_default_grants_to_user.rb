class AddDefaultGrantsToUser < ActiveRecord::Migration
  def change
    add_column :users, :grants, :integer, { :default => 10 }
  end
end