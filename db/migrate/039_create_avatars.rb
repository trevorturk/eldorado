class CreateAvatars < ActiveRecord::Migration
  def self.up
    create_table :avatars do |t|
      t.column :parent_id, :integer
      t.column :content_type, :string
      t.column :filename, :string
      t.column :thumbnail, :string
      t.column :size, :integer
      t.column :width, :integer
      t.column :height, :integer
      t.column :user_id, :integer
      t.column :current_user_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    add_column :users, :avatars_count, :integer, :default => 0
    add_column :users, :avatar_id, :integer
    remove_column :users, :avatar
  end

  def self.down
    drop_table :avatars
    remove_column :users, :avatars_count
    remove_column :users, :avatar_id
    add_column :users, :avatar, :string, :default => 0
  end
end
