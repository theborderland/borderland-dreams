class AddEmailToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :email, :string , :limit => 64, null: false, default: ""
  end
end
