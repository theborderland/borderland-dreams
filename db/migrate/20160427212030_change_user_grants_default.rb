class ChangeUserGrantsDefault < ActiveRecord::Migration
  def up
    change_column_default :users, :grants, 10
  end

  def down
    change_column_default :users, :grants, 8
  end
end
