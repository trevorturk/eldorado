class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.integer :user_id
      t.string :title
      t.text :body
      t.datetime :created_at
      t.datetime :updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
