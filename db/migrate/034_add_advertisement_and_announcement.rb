class AddAdvertisementAndAnnouncement < ActiveRecord::Migration
  def self.up
    add_column :options, :announcement, :text
    add_column :options, :advertisement, :text
  end

  def self.down
    remove_column :options, :announcement
    remove_column :options, :advertisement
  end
end
