class CreateNewbies < ActiveRecord::Migration
  def self.up
    create_table :newbies do |t|
      t.column :term, :string
    end
  end

  def self.down
    drop_table :newbies
  end
end
