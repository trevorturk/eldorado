class RemoveUpdatedAtFromTopics < ActiveRecord::Migration
  def self.up
    remove_column :topics, :updated_at
  end

  def self.down
    add_column :topics, :updated_at, :datetime
  end
end
