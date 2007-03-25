class AddVotesToHeaders < ActiveRecord::Migration
  def self.up
    add_column :headers, :votes, :integer, :default => 0
  end

  def self.down
    remove_column :headers, :votes
  end
end
