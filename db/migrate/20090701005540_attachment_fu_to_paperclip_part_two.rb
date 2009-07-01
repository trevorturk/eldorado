class AttachmentFuToPaperclipPartTwo < ActiveRecord::Migration
  def self.up
    [:avatars, :uploads, :headers, :themes].each do |table|
      remove_column table, :parent_id
      remove_column table, :content_type
      remove_column table, :filename
      remove_column table, :thumbnail
      remove_column table, :size
      remove_column table, :width
      remove_column table, :height
    end
  end

  def self.down
    [:avatars, :uploads, :headers, :themes].each do |table|
      add_column table, :parent_id, :integer
      add_column table, :content_type, :string
      add_column table, :filename, :string
      add_column table, :thumbnail, :string
      add_column table, :size, :integer
      add_column table, :width, :integer
      add_column table, :height, :integer
    end
  end
end
