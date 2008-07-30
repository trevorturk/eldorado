class AddArticlesCountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :articles_count, :integer, :default => 0
    User.all.each do |u|
      u.update_attribute(:articles_count, u.articles.count)
    end
  end

  def self.down
    remove_column :users, :articles_count
  end
end
