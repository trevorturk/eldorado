class UseRailsNewDefaultTimeZones < ActiveRecord::Migration
  def self.up
    @users = User.all
    @users.each do |user|
      user.time_zone = 'UTC' if user.time_zone.blank?
      tz = TZInfo::Timezone.get(user.time_zone) rescue ActiveSupport::TimeZone[user.time_zone] || ActiveSupport::TimeZone['UTC']
      time_zone = if tz.is_a?(TZInfo::Timezone)
        linked_timezone = tz.instance_variable_get('@linked_timezone')
        name = linked_timezone ? linked_timezone.name : tz.name
        ActiveSupport::TimeZone::MAPPING.index(name)
      else
        tz.name
      end
      user.update_attribute(:time_zone, time_zone) unless time_zone == user.time_zone
    end unless @users.empty?
  end

  def self.down
  end
end
