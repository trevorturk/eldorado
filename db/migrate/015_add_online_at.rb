class AddOnlineAt < ActiveRecord::Migration
  def self.up
    add_column :users, :online_at, :datetime
    User.find(:all).each do |t|
      t.update_attribute :online_at, Time.now.utc
    end
  end

  def self.down
    remove_column :users, :online_at
  end
end
