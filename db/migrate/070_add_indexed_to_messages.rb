class AddIndexedToMessages < ActiveRecord::Migration
  def self.up
    add_index "messages", ["created_at"], :name => "index_messages_on_created_at"
  end

  def self.down
    remove_index "messages", :name => "index_messages_on_created_at"
  end
end
