class AddUserCreateAndUpdatedToHeaders < ActiveRecord::Migration
  def self.up
    add_column :headers, :description, :text
    add_column :headers, :user_id, :integer
    add_column :headers, :created_at, :datetime
    add_column :headers, :updated_at, :datetime
    Header.find(:all).each do |h|
      h.update_attribute :user_id, 1 if h.user_id.nil?
      h.update_attribute :created_at, Time.now.utc if h.created_at.nil?
      h.update_attribute :updated_at, Time.now.utc if h.updated_at.nil?
    end
  end

  def self.down
    remove_column :headers, :user_id
    remove_column :headers, :created_at
    remove_column :headers, :updated_at
  end
end
