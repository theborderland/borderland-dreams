class AddColorToCamp < ActiveRecord::Migration[5.0]
  def change
    add_column :camps, :color, :string
  end
end
