class SetDefaultCoinsToZero < ActiveRecord::Migration
  def up
    change_column_default :users, :grants, 0
  end

  def down
    change_column_default :users, :grants, 10
  end
end
