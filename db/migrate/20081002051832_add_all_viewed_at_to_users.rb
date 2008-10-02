class AddAllViewedAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :all_viewed_at, :datetime
    User.update_all(:all_viewed_at => Time.now)
  end

  def self.down
    remove_column :users, :all_viewed_at
  end
end
