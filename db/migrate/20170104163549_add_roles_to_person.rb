class AddRolesToPerson < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :identifier
    end

    create_table :people_roles do |t|
      t.belongs_to :person, index: true
      t.belongs_to :role, index: true
    end
  end
end
