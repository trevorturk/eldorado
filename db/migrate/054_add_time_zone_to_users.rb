class AddTimeZoneToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :time_zone, :string, :default => 'Etc/UTC'
  end

  def self.down
    remove_column :users, :time_zone
  end
end
