class AddGrantingToggle < ActiveRecord::Migration
  def change
    add_column :camps, :grantingtoggle, :boolean, null: false, default: false
  end
end
