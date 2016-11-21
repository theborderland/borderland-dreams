class AddSafetybagMembersToCamp < ActiveRecord::Migration
  def change
    add_column :camps, :safetybag_firstMemberName, :string, :limit => 64
    add_column :camps, :safetybag_firstMemberEmail, :string, :limit => 64
    add_column :camps, :safetybag_secondMemberName, :string, :limit => 64
    add_column :camps, :safetybag_secondMemberEmail, :string, :limit => 64
  end
end
