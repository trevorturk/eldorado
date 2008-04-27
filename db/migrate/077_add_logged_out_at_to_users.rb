class AddLoggedOutAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :logged_out_at, :datetime
    remove_index :users, :name => :index_users_on_online_at
    remove_index :users, :name => :index_users_on_chatting_at
    add_index :users, [:online_at, :chatting_at, :logged_out_at], :name => :index_users_on_activity
    change_column :settings, :login_message, :string, :default => nil
  end

  def self.down
    remove_column :users, :logged_out_at
    add_index :users, :online_at, :name => :index_users_on_online_at
    add_index :users, :chatting_at, :name => :index_users_on_chatting_at
    remove_index :users, :name => :index_users_on_activity
    change_column :settings, :login_message, :string, :default => 'You are not logged in'
  end
end