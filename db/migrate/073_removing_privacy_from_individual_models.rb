class RemovingPrivacyFromIndividualModels < ActiveRecord::Migration
  def self.up
    remove_column :topics, :private
    remove_column :uploads, :private
    remove_column :events, :private
  end

  def self.down
    raise IrreversibleMigration
  end
end
