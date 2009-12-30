class AddClickableHeaderSetting < ActiveRecord::Migration
  def self.up
    add_column :settings, :clickable_header, :boolean, :default => false
  end

  def self.down
    remove_column :settings, :clickable_header
  end
end
