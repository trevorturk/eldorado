class AddStickyToTopicsAndOtherCleanups < ActiveRecord::Migration
  def self.up
    remove_column :topics, :forum_id
    add_column :topics, :sticky, :boolean, :default => false
    add_column :topics, :forum_id, :integer
    change_column :users, :admin, :boolean, :default => false
  end

  def self.down
    add_column :topics, :forum_id
    remove_column :topics, :sticky, :boolean, :default => false
    remove_column :topics, :forum_id, :integer
    change_column :users, :admin, :boolean
  end
end
