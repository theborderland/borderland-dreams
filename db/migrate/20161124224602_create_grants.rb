class CreateGrants < ActiveRecord::Migration
  def change
    create_table :grants do |t|
      t.integer :user_id
      t.integer :camp_id
      t.integer :amount

      t.timestamps null: false
    end
  end
end
