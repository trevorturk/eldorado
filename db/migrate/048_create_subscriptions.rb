class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.column :user_id, :integer
      t.column :topic_id, :integer
    end
  end

  def self.down
    drop_table :subscriptions
  end
end
