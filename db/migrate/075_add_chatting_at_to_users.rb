class AddChattingAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :chatting_at, :datetime
  end

  def self.down
    remove_column :users, :chatting_at
  end
end
