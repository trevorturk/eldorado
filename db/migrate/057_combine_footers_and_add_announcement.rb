class CombineFootersAndAddAnnouncement < ActiveRecord::Migration
  def self.up
    rename_column :options, :footer_left, :announcement
    rename_column :options, :footer_right, :footer
  end

  def self.down
    rename_column :options, :announcement, :footer_left
    rename_column :options, :footer, :footer_right
  end
end
