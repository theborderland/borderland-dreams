class CreateFlagEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :flag_events do |t|
      t.references :flag_definition, foreign_key: true
      t.references :user, foreign_key: true
      t.references :camp, foreign_key: true
      t.boolean :value

      t.timestamps
    end
  end
end
