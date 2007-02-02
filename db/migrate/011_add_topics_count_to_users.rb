class AddTopicsCountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :topics_count, :integer, :default => 0
  end

  def self.down
    remove_column :users, :topics_count
  end
end
