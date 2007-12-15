class AddTimezoneToSetting < ActiveRecord::Migration
  def self.up
    add_column :settings, :time_zone, :string, :default => "UTC"
    change_column :users, :time_zone, :string, :default => nil
  end

  def self.down
    remove_column :settings, :time_zone
    change_column :users, :time_zone, :string, :default => "UTC"
  end
end
