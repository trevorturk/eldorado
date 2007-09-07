class ChangeClosedToLocked < ActiveRecord::Migration
  def self.up
    rename_column :topics, :closed, :locked
  end

  def self.down
    rename_column :topics, :locked, :closed
  end
end
