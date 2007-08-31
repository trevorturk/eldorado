class RemoveEventsLocation < ActiveRecord::Migration
  def self.up
    remove_column :events, :location
  end

  def self.down
    raise IrreversibleMigration
  end
end
