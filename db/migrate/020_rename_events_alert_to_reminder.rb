class RenameEventsAlertToReminder < ActiveRecord::Migration
  def self.up
    rename_column :events, :alert, :reminder
  end

  def self.down
    rename_column :events, :reminder, :alert
  end
end
