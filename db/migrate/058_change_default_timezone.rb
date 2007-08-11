class ChangeDefaultTimezone < ActiveRecord::Migration
  def self.up
    change_column :users, :time_zone, :string, :default => 'UTC'
  end

  def self.down
    change_column :users, :time_zone, :string, :default => 'Etc/UTC'
  end
end
