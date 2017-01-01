class AddCampToPeople < ActiveRecord::Migration
  def change
    add_column :people, :camp_id, :integer
    change_column :people, :camp_id, :integer, null: false
    add_index :people, :camp_id

    add_column :responsibles, :responsibility_type, :string
    change_column :responsibles, :responsibility_type, :string, null: false
    remove_column :people, :responsibility_type
  end
end
