class AddUsersUpdatedAt < ActiveRecord::Migration

  class User < ActiveRecord::Base; end

  def self.up
    add_column :users, :updated_at, :datetime
    User.find(:all).each do |t|
      t.update_attribute :updated_at, Time.now.utc
    end
  end

  def self.down
    remove_column :users, :updated_at
  end
  
end
