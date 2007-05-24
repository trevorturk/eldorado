class RemoveUnusedOptions < ActiveRecord::Migration
  def self.up
    remove_column :options, :avatars_path
    remove_column :options, :login_image
    remove_column :options, :announcement
    remove_column :options, :advertisement        
    remove_column :options, :invitation_only  
    remove_column :options, :private_site  
  end

  def self.down
    add_column :options, :avatars_path, :string
    add_column :options, :login_image, :string
    add_column :options, :announcement, :text
    add_column :options, :advertisement, :text
    add_column :options, :invitation_only, :boolean,  :default => false
    add_column :options, :private_site, :boolean, :default => false
  end
end
