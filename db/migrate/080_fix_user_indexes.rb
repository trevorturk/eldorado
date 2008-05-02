class FixUserIndexes < ActiveRecord::Migration
  def self.up
    remove_index :users, :name => :index_users_on_activity
    add_index :users, [:chatting_at], :name => :index_users_on_chatting_at
  end

  def self.down
    add_index :users, [:online_at, :chatting_at, :logged_out_at], :name => :index_users_on_activity
    remove_index :users, :name => :index_users_on_chatting_at
  end
end
