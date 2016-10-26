class RemoveIdRegisteredFromTickets < ActiveRecord::Migration
  def change
  	remove_column :tickets, :id_registered
  end
end
