class AttachmentFuToPaperclipPartOne < ActiveRecord::Migration
  def self.up
    [:avatars, :uploads, :headers, :themes].each do |table|
      add_column table, :attachment_file_name, :string
      add_column table, :attachment_content_type, :string
      add_column table, :attachment_file_size, :integer
      add_column table, :attachment_remote_url, :string
    end
    Migrator.attachment_fu_to_paperclip
  end

  def self.down
    [:avatars, :uploads, :headers, :themes].each do |table|
      remove_column table, :attachment_file_name
      remove_column table, :attachment_content_type
      remove_column table, :attachment_file_size
      remove_column table, :attachment_remote_url
    end
  end
end
