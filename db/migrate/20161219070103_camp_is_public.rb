class CampIsPublic < ActiveRecord::Migration
  def change
    add_column :camps, :is_public, :boolean, null: false, default: false
  end
end