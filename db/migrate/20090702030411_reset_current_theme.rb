class ResetCurrentTheme < ActiveRecord::Migration
  def self.up
    settings_theme = Setting.first.theme rescue nil
    if settings_theme
      current_theme = Theme.find_by_attachment_file_name(settings_theme)
      current_theme.select
    end
  end

  def self.down
  end
end
