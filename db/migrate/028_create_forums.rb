class CreateForums < ActiveRecord::Migration
  def self.up
    create_table :forums do |t|
      t.column :category_id, :integer
      t.column :name, :string
      t.column :description, :text
      t.column :topics_count, :integer, :default => 0
      t.column :posts_count, :integer, :default => 0
      t.column :position, :integer, :default => 0
      t.column :last_post_id, :integer
      t.column :last_post_at, :integer
      t.column :last_post_by, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    add_column :topics, :forum_id, :integer    
  end

  def self.down
    drop_table :forums
    remove_column :topics, :forum_id
  end
end
