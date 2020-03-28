class AddIsInArtwalkToCamp < ActiveRecord::Migration[5.0]
  def change
    add_column :camps, :is_in_artwalk, :bool
  end
end
