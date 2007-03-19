class AddHeadersCounterCacheToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :headers_count, :integer, :default => 0
  end

  def self.down
    remove_column :users, :headers_count
  end
end
