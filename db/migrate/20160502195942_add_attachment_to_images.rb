class AddAttachmentToImages < ActiveRecord::Migration
  def self.up
    add_attachment :images, :attachment, :after => :camp_id
  end

  def self.down
    remove_attachment :images, :attachment
  end
end
