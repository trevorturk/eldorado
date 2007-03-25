class RemoveNewbieModel < ActiveRecord::Migration
  def self.up
    drop_table :newbies
    add_column :options, :newest_user, :string
  end

  def self.down
    create_table :newbies do |t|
      t.column :term, :string
    end
    remove_column :options, :newest_user, :string
  end
end
