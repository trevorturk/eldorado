class AllNilUsersOnlineAt < ActiveRecord::Migration
  def self.up
    change_column :users, :online_at, :datetime, :default => nil
  end

  def self.down
    change_column :users, :online_at, :datetime
  end
end
