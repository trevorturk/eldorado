class AddIndexesForChat < ActiveRecord::Migration
  def self.up
    add_index "users", ["chatting_at"], :name => "index_users_on_chatting_at"
  end

  def self.down
    remove_index "users", :name => "index_users_on_chatting_at" 
  end
end
