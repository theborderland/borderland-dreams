class AddSafetyFileCommentsToDream < ActiveRecord::Migration
  def change
    add_column :camps, :safety_file_comments, :string, :limit => 4096
  end
end
