class AddLocationToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :location, :text
  end

  def self.down
    remove_column :events, :location
  end
end
