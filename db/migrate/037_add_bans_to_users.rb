class AddBansToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :banned_until, :datetime
    add_column :users, :ban_message, :string
  end

  def self.down
    remove_column :users, :banned_until
    remove_column :users, :ban_message
  end
end
