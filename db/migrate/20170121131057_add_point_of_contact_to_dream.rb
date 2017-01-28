class AddPointOfContactToDream < ActiveRecord::Migration
  def change
    add_column :camps, :dream_point_of_contact_email, :string, :limit => 64
  end
end
