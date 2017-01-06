class DropResponsible < ActiveRecord::Migration
  def change
    drop_table :responsibles
  end
end
