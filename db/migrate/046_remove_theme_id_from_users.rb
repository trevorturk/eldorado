class RemoveThemeIdFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :theme_id
  end

  def self.down
    add_column :users, :theme_id, :integer
  end
end
