class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :email
      t.string :phone_number
      t.string :background
      t.string :responsibility_type

      t.timestamps null: false
    end
  end
end