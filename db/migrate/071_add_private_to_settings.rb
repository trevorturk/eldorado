class AddPrivateToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :private, :boolean, :default => false
  end

  def self.down
    remove_column :settings, :private
  end
end
