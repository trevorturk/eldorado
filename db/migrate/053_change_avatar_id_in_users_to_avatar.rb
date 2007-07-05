class ChangeAvatarIdInUsersToAvatar < ActiveRecord::Migration
  def self.up
    rename_column :users, :avatar_id, :avatar
    change_column :users, :avatar, :string
  end

  def self.down
    raise IrreversibleMigration
  end
end
