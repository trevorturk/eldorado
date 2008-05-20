class MoveBansToUsersTable < ActiveRecord::Migration
  def self.up
    add_column :users, :ban_message, :string
    add_column :users, :banned_until, :datetime
    
    begin
      @bans = Ban.find(:all)
      @bans.each do |ban|
        User.update_all(['ban_message = ?, banned_until = ?', ban.message, ban.expires_at], ['id = ?', ban.user_id])
      end
    rescue
    end
    
    drop_table :bans
  end

  def self.down
    raise IrreversibleMigration
  end
end
