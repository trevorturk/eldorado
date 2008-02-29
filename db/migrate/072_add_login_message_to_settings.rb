class AddLoginMessageToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :login_message, :string, :default => 'You are not logged in'
  end

  def self.down
    remove_column :settings, :login_message
  end
end
