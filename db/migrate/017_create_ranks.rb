class CreateRanks < ActiveRecord::Migration
  def self.up
    create_table :ranks do |t|
      t.column :title, :string
      t.column :min_posts, :integer
    end
    Ranks.create :title => "New Member", :min_posts => "0"
    Ranks.create :title => "Member", :min_posts => "10"
  end

  def self.down
    drop_table :ranks
  end
end
