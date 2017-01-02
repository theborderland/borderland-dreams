class SetCampContactEmailNotNull < ActiveRecord::Migration
  def change
    change_column :camps, :contact_email, :string, null: true
  end
end
