class RemoveCruftFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :updated_at
    remove_column :users, :topics_count
    remove_column :users, :headers_count
    remove_column :users, :events_count
    remove_column :users, :uploads_count
    remove_column :users, :avatars_count
    remove_column :users, :themes_count
  end

  def self.down
    add_column :users, :updated_at, :datetime
    add_column :users, :topics_count, :integer, :default => 0
    add_column :users, :headers_count, :integer, :default => 0
    add_column :users, :events_count, :integer, :default => 0
    add_column :users, :uploads_count, :integer, :default => 0
    add_column :users, :avatars_count, :integer, :default => 0
    add_column :users, :themes_count, :integer, :default => 0
  end
end
