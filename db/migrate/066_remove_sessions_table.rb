class RemoveSessionsTable < ActiveRecord::Migration
  def self.up
    drop_table :sessions
  end

  def self.down
    raise IrreversibleMigration
  end
end
