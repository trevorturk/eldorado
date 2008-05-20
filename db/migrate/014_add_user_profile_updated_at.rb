class AddUserProfileUpdatedAt < ActiveRecord::Migration
  def self.up
    add_column :users, :profile_updated_at, :datetime
    User.find(:all).each do |t|
      t.update_attribute :profile_updated_at, Time.now.utc
    end
  end

  def self.down
    remove_column :users, :profile_updated_at
  end
end
