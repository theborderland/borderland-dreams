class AddHasTicketAndEarlyArrivalToPerson < ActiveRecord::Migration
  def change
    add_column :people, :has_ticket, :boolean
    add_column :people, :needs_early_arrival, :boolean
  end
end
