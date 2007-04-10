class RemoveCreatedAtUpdatedAtFromForums < ActiveRecord::Migration
  def self.up
    remove_column :forums, :created_at
    remove_column :forums, :updated_at
  end

  def self.down
    add_column :forums, :created_at, :datetime
    add_column :forums, :updated_at, :datetime
  end
end
