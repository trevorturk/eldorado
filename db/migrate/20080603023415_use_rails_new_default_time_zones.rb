class UseRailsNewDefaultTimeZones < ActiveRecord::Migration
  def self.up
    @users = User.all
    @users.each do |user|
      user.time_zone = 'UTC' if user.time_zone.nil?
      tz = TZInfo::Timezone.get(user.time_zone) rescue TimeZone[user.time_zone] || TimeZone['UTC']
      linked_timezone = tz.instance_variable_get('@linked_timezone')
      time_zone = linked_timezone ? TimeZone::MAPPING.index(linked_timezone.name) : tz.name
      user.update_attribute(:time_zone, time_zone)
    end unless @users.empty?
  end

  def self.down
  end
end
