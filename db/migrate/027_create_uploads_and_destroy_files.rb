class CreateUploadsAndDestroyFiles < ActiveRecord::Migration
  def self.up
    create_table :uploads do |t|
      t.column :parent_id, :integer
      t.column :content_type, :string
      t.column :filename, :string
      t.column :thumbnail, :string
      t.column :size, :integer
      t.column :width, :integer
      t.column :height, :integer
      t.column :user_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    drop_table :files
    add_column :users, :uploads_count, :integer, :default => 0
  end

  def self.down
    drop_table :uploads
    remove_column :users, :uploads_count
  end
end
