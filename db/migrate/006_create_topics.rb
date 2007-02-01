class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.column :user_id,             :integer
      t.column :user_name,           :string
      t.column :title,               :string
      t.column :created_at,          :datetime
      t.column :updated_at,          :datetime
      t.column :views,               :integer,  :default => 0
      t.column :replies,             :integer,  :default => 0
      t.column :last_post_id,        :integer
      t.column :last_post_at,        :datetime
      t.column :last_post_user_id,   :integer
      t.column :last_post_user_name, :string
      t.column :private,             :boolean,  :default => false
      t.column :closed,              :boolean,  :default => false
    end
  end

  def self.down
    drop_table :topics
  end
end
