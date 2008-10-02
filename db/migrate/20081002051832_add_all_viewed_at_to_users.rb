class AddAllViewedAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :all_viewed_at, :datetime
    User.all.each do |u|
      u.update_attribute(:all_viewed_at, u.online_at)
    end
  end

  def self.down
    remove_column :users, :all_viewed_at
  end
end
