class AddingIndexes < ActiveRecord::Migration
  def self.up
    add_index "posts", ["topic_id"], :name => "index_posts_on_topic_id"
    add_index "posts", ["user_id", "created_at"], :name => "index_posts_on_user_id"
    add_index "topics", ["forum_id"], :name => "index_topics_on_forum_id"
    add_index "topics", ["forum_id", "last_post_at"], :name => "index_topics_on_last_post_at"
    add_index "users", ["online_at"], :name => "index_users_on_online_at"
    add_index "forums", ["category_id"], :name => "index_forums_on_category_id"    
    add_index "forums", ["category_id", "last_post_at"], :name => "index_forums_on_last_post_at"
    add_index "events", ["date"], :name => "index_events_on_date"
  end

  def self.down
    remove_index "posts", :name => "index_posts_on_topic_id"
    remove_index "posts", :name => "index_posts_on_user_id"
    remove_index "topics", :name => "index_topics_on_forum_id"
    remove_index "topics", :name => "index_topics_on_last_post_at"
    remove_index "users", :name => "index_users_on_online_at"
    remove_index "forums", :name => "index_forums_on_category_id"    
    remove_index "forums", :name => "index_forums_on_last_post_at"    
    remove_index "events", :name => "index_events_on_date"    
  end
end
