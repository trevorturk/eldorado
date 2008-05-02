class RemoveUserIndexOnLoggedOutAt < ActiveRecord::Migration
  def self.up
    remove_index :users, :name => :index_users_on_online_at_and_logged_out_at rescue nil
  end

  def self.down
    raise IrreversibleMigration
  end
end
