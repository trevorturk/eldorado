class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :login,          :string
      t.column :email,          :string
      t.column :password_hash,  :string
      t.column :created_at,     :datetime
      t.column :last_login_at,  :datetime
      t.column :admin,          :boolean
      t.column :posts_count,    :integer,  :default => 0
      t.column :signature,      :string
      t.column :avatar,         :string
    end
  end

  def self.down
    drop_table :users
  end
end
