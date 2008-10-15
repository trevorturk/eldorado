class AddIndexToViewings < ActiveRecord::Migration
  def self.up
    add_index :viewings, :topic_id
  end

  def self.down
    remove_index :viewings, :topic_id
  end
end
