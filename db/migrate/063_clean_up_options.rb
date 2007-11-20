class CleanUpOptions < ActiveRecord::Migration
  def self.up
    rename_column :options, :site_title, :title
    rename_column :options, :site_tagline, :tagline
    remove_column :options, :admin_rank
    remove_column :options, :newest_user
  end

  def self.down
    raise IrreversibleMigration
  end
end
