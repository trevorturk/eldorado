class AddPrivateToFiles < ActiveRecord::Migration
  def self.up
    add_column :uploads, :private, :boolean, :default => false
  end

  def self.down
    remove_column :uploads, :private
  end
end
