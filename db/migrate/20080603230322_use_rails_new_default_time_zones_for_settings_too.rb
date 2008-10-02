class UseRailsNewDefaultTimeZonesForSettingsToo < ActiveRecord::Migration
  def self.up
    @settings = Setting.all
    @settings.each do |setting|
      setting.time_zone = 'UTC' if setting.time_zone.blank?
      tz = TZInfo::Timezone.get(setting.time_zone) rescue ActiveSupport::TimeZone[setting.time_zone] || ActiveSupport::TimeZone['UTC']
      time_zone = if tz.is_a?(TZInfo::Timezone)
        linked_timezone = tz.instance_variable_get('@linked_timezone')
        name = linked_timezone ? linked_timezone.name : tz.name
        ActiveSupport::TimeZone::MAPPING.index(name)
      else
        tz.name
      end
      setting.update_attribute(:time_zone, time_zone) unless time_zone == setting.time_zone
    end unless @settings.empty?
  end

  def self.down
  end
end
