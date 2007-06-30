class AddRememberMe < ActiveRecord::Migration
  def self.up
    add_column :users, :auth_token, :string
    add_column :users, :auth_token_exp, :datetime
  end

  def self.down
    remove_column :users, :auth_token
    remove_column :users, :auth_token_exp
  end
end
