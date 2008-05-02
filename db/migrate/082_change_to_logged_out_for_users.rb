class ChangeToLoggedOutForUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :logged_out_at
    add_column :users, :logged_out, :boolean, :default => false
  end

  def self.down
    raise IrreversibleMigration
  end
end
