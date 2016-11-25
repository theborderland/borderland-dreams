class RemoveGrantsReceivedFromCamp < ActiveRecord::Migration
  def change
    remove_column :camps, :grants_received, :integer
  end
end
