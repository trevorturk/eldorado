class AddLoggedOutForAllUsers < ActiveRecord::Migration
  def self.up
    User.find(:all).each do |t|
      t.update_attribute :logged_out_at, t.created_at
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end
