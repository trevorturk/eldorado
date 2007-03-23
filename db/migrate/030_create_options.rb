class CreateOptions < ActiveRecord::Migration
  def self.up
    create_table :options do |t|
      t.column :site_title, :string
      t.column :site_tagline, :string
      t.column :footer_left, :text
      t.column :footer_right, :text
      t.column :invitation_only, :boolean, :default => false
      t.column :private_site, :boolean, :default => false
      t.column :admin_rank, :string
      t.column :avatars_path, :string 
    end
  end

  def self.down
    drop_table :options
  end
end
