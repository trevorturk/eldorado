class RemoveMoreTopicsCruft < ActiveRecord::Migration
  def self.up
    remove_column :topics, :last_post_at
    remove_column :topics, :last_post_by
  end

  def self.down
    add_column :topics, :last_post_at, :datetime
    add_column :topics, :last_post_by, :integer
  end
end
