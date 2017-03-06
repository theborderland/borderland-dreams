class AddRemoteUserIdToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :remote_user_id, :integer
  end
end
