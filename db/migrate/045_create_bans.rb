class CreateBans < ActiveRecord::Migration
  def self.up
    create_table :bans do |t|
      t.column :user_id, :integer
      t.column :ip, :string
      t.column :email, :string
      t.column :message, :string
      t.column :expires_at, :datetime
    end
    remove_column :users, :banned_until
    remove_column :users, :ban_message
  end

  def self.down
    drop_table :bans
    add_column :users, :banned_until, :datetime
    add_column :users, :ban_message, :string
  end
end
