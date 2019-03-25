class AddLoomioThreadIdToCamp < ActiveRecord::Migration[5.0]
  def change
    change_table :camps do |t|
      t.string :loomio_thread
    end
  end
end
