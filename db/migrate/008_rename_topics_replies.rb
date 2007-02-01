class RenameTopicsReplies < ActiveRecord::Migration
  def self.up
    rename_column :topics, :replies, :posts_count
  end

  def self.down
    rename_column :topics, :posts_count, :replies
  end
end
