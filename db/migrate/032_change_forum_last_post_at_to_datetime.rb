class ChangeForumLastPostAtToDatetime < ActiveRecord::Migration
  def self.up
    change_column :forums, :last_post_at, :datetime
  end

  def self.down
    change_column :forums, :last_post_at, :integer
  end
end
