class AddAdminOnlyCreateSetting < ActiveRecord::Migration
  def self.up
    add_column :settings, :admin_only_create, :string, :null => false, :default => ''
  end

  def self.down
    remove_column :settings, :admin_only_create
  end
end
