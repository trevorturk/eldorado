class RemoveDuplicationFromTopicModel < ActiveRecord::Migration
  def self.up
    remove_column :topics, :user_name
    remove_column :topics, :last_post_user_name
    rename_column :topics, :last_post_user_id, :last_post_by
  end

  def self.down
    add_column :topics, :user_name, :text
    add_column :topics, :last_post_user_name, :text
    rename_column :topics, :last_post_by, :last_post_user_id
  end
end
