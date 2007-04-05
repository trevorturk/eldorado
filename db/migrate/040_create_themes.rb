class CreateThemes < ActiveRecord::Migration
  def self.up
    create_table :themes do |t|
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
    add_column :options, :theme_id, :integer
  end

  def self.down
    drop_table :themes
    remove_column :options, :theme_id
  end
end
