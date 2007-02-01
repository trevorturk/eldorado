class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.column :user_id,    :integer
      t.column :topic_id,   :integer
      t.column :body,       :text
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :updated_by, :integer
    end
  end

  def self.down
    drop_table :posts
  end
end
