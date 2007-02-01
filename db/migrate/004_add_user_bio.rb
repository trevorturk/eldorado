class AddUserBio < ActiveRecord::Migration
  def self.up
    add_column :users, :bio, :string
  end

  def self.down
    remove_column :users, :bio
  end
end
