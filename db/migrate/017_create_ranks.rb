class CreateRanks < ActiveRecord::Migration
  def self.up
    create_table :ranks do |t|
      t.column :title, :string
      t.column :min_posts, :integer
    end
  end

  def self.down
    drop_table :ranks
  end
end
