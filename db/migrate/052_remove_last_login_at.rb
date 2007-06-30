class RemoveLastLoginAt < ActiveRecord::Migration
  def self.up
    remove_column :users, :last_login_at
  end

  def self.down
    raise IrreversibleMigration
  end
end
