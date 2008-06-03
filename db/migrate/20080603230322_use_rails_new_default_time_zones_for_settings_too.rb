class UseRailsNewDefaultTimeZonesForSettingsToo < ActiveRecord::Migration
  def self.up
    @settings = Setting.all
    @settings.each do |setting|
      setting.time_zone = 'UTC' if setting.time_zone.nil?
      tz = TZInfo::Timezone.get(setting.time_zone) rescue TimeZone[setting.time_zone] || TimeZone['UTC']
      linked_timezone = tz.instance_variable_get('@linked_timezone')
      time_zone = linked_timezone ? TimeZone::MAPPING.index(linked_timezone.name) : tz.name
      setting.update_attribute(:time_zone, time_zone)
    end unless @settings.empty?
  end

  def self.down
  end
end
