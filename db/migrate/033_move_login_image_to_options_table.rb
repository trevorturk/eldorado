class MoveLoginImageToOptionsTable < ActiveRecord::Migration
  def self.up
    add_column :options, :login_image, :string
  end

  def self.down
    remove_column :options, :login_image
  end
end
