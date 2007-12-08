class ChangeSettingsThemeIdToTheme < ActiveRecord::Migration
  def self.up
    rename_column :settings, :theme_id, :theme
    change_column :settings, :theme, :string
    
    settings = Setting.find(:first)
    return if settings.blank?
    settings.theme = Theme.find(settings.theme).filename
    settings.save
  end

  def self.down
    raise IrreversibleMigration
  end
end
