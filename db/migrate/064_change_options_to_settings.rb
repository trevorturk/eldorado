class ChangeOptionsToSettings < ActiveRecord::Migration
  def self.up
    rename_table :options, :settings
  end

  def self.down
    rename_table :settings, :options
  end
end
