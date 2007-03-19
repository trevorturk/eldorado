class AddUserAndCounterCacheForEvents < ActiveRecord::Migration
  def self.up
    add_column :users, :events_count, :integer, :default => 0
    add_column :events, :user_id, :integer
    Event.find(:all).each do |e|
      e.update_attribute :user_id, 1 if e.user_id.nil?
    end
  end

  def self.down
    remove_column :users, :events_count
    remove_column :events, :user_id
  end
end
