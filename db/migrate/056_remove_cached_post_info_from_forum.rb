class RemoveCachedPostInfoFromForum < ActiveRecord::Migration
  def self.up
    remove_index :forums, :name => :index_forums_on_last_post_at
    remove_column :forums, :last_post_id
    remove_column :forums, :last_post_at
    remove_column :forums, :last_post_by
  end

  def self.down
    raise IrreversibleMigration
  end
end
