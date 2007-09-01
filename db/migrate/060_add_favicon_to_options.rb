class AddFaviconToOptions < ActiveRecord::Migration
  def self.up
    add_column :options, :favicon, :string
  end

  def self.down
    remove_column :options, :favicon
  end
end
