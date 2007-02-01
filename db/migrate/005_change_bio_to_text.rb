class ChangeBioToText < ActiveRecord::Migration
  def self.up
    change_column :users, :bio, :text
  end

  def self.down
    change_column :users, :bio, :string
  end
end
