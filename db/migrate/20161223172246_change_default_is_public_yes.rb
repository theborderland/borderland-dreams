class ChangeDefaultIsPublicYes < ActiveRecord::Migration
  def change
    change_column_default :camps, :is_public, true
  end
end
