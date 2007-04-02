class ChangeCategoriesPositionToInteger < ActiveRecord::Migration
  def self.up
    change_column :categories, :position, :integer, :default => 0
  end

  def self.down
    change_column :categories, :position, :string
  end
end
