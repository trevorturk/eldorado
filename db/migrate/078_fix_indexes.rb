class FixIndexes < ActiveRecord::Migration
  def self.up
    remove_index :forums, :name => :index_forums_on_category_id
    remove_index :forums, :name => :index_forums_on_last_post_at rescue nil
    remove_index :posts, :name => :index_posts_on_topic_id
    remove_index :topics, :name => :index_topics_on_forum_id
    remove_index :topics, :name => :index_topics_on_last_post_at
    add_index :posts, [:topic_id, :created_at], :name => :index_posts_on_topic_id_and_created_at
    add_index :topics, [:forum_id, :last_post_at], :name => :index_topics_on_forum_id_and_last_post_at
  end

  def self.down
    add_index :forums, [:category_id], :name => :index_forums_on_category_id
    add_index :forums, [:category_id], :name => :index_forums_on_last_post_at
    add_index :posts, [:topic_id], :name => :index_posts_on_topic_id
    add_index :topics, [:forum_id], :name => :index_topics_on_forum_id
    add_index :topics, [:forum_id, :last_post_at], :name => :index_topics_on_last_post_at
    remove_index :posts, :name => :index_posts_on_topic_id_and_created_at
    remove_index :topics, :name => :index_topics_on_forum_id_and_last_post_at
  end
end
