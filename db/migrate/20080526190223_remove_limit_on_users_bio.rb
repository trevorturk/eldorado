class RemoveLimitOnUsersBio < ActiveRecord::Migration
  def self.up
    change_column :users, :bio, :text, :limit => false rescue nil
  end

  def self.down
    change_column :users, :bio, :text, :limit => 255
  end
end
