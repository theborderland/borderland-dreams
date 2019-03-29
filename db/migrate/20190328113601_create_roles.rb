class CreateRoles < ActiveRecord::Migration[5.0]
   def change
    drop_table :roles

    create_table :roles do |t|
      t.string :name
      t.belongs_to :user
      t.timestamps
    end
   end
end
