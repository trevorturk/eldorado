class AddStickyIndexToTopics < ActiveRecord::Migration
  def self.up
    add_index :topics, [:forum_id, :sticky, :last_post_at], :name => :index_topics_on_sticky_and_last_post_at
    
  end

  def self.down
    remove_index :topics, :name => :index_topics_on_sticky_and_last_post_at
  end
end
