class MakeSurePostsCountDefaultIs0 < ActiveRecord::Migration
  class Topic < ActiveRecord::Base; end
  def self.up
    change_column :topics, :posts_count, :integer, :default => 0
    Topic.find(:all).each do |t|
      t.update_attribute :posts_count, 1 if t.posts_count.nil?
    end
  end

  def self.down
    change_column :topics, :posts_count, :integer, :default => nil
    Topic.find(:all).each do |t|
      t.update_attribute :posts_count, nil if t.posts_count == 1
    end
  end
end
