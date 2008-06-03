class MoveTimeZoneDefaultToSettingModel < ActiveRecord::Migration
  def self.up
    change_column(:settings, :time_zone, :string, :default => nil)
  end

  def self.down
    change_column(:settings, :time_zone, :string, :default => 'UTC')
  end
end
