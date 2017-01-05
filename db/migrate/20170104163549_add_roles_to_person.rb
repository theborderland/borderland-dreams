class AddRolesToPerson < ActiveRecord::Migration
  def change
    add_column :people, :roles, :string
  end
end
