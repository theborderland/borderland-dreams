class RemoveBlobsFromImages < ActiveRecord::Migration
  def self.up
    remove_column :images, :image
  end

  def self.down
   add_column :images, :image, :binary, :limit => 1.megabytes
  end
end
