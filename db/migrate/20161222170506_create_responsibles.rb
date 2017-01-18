class CreateResponsibles < ActiveRecord::Migration
  def change
  	create_table :responsibles do |t|

      t.timestamps null: false
    end
  end
end
