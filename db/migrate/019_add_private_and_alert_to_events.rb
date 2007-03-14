class AddPrivateAndAlertToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :private, :boolean, :default => false
    add_column :events, :alert, :boolean, :default => false
  end

  def self.down
  end
end
