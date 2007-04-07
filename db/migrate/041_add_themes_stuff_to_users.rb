class AddThemesStuffToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :themes_count, :integer, :default => 0
    add_column :users, :theme_id, :integer
  end

  def self.down
    remove_column :users, :themes_count
    remove_column :users, :theme_id
  end
end
