class CreateLogEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :log_entries do |t|
      t.timestamps
      t.string :topic
      t.string :type
      t.integer :user_id
      t.string :user_name
      t.integer :object_id
      t.string :object_name
      t.string :description
      t.boolean :loomio_consumed
    end
  end
end
