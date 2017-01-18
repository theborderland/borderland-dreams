class MakeSubtitleLonger < ActiveRecord::Migration
  def up
    change_column :camps, :subtitle, :text
  end

  def down
    change_column :camps, :subtitle, :string
  end
end
