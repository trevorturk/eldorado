class AddCreatedAtAndUpdatedAtToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :created_at, :datetime
    add_column :events, :updated_at, :datetime
    Event.find(:all).each do |e|
      e.update_attribute :created_at, Time.now.utc if e.created_at.nil?
      e.update_attribute :updated_at, Time.now.utc if e.updated_at.nil?
    end
  end

  def self.down
    remove_column :events, :created_at
    remove_column :events, :updated_at
  end
end
