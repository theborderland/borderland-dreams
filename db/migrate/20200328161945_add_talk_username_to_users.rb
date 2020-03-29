class AddTalkUsernameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :talk_username, :string
    add_column :users, :talk_id, :integer
  end
end
