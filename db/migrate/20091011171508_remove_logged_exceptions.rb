class RemoveLoggedExceptions < ActiveRecord::Migration
  def self.up
    drop_table :logged_exceptions
  end

  def self.down
  end
end
