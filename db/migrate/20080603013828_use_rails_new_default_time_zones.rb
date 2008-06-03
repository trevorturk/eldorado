class UseRailsNewDefaultTimeZones < ActiveRecord::Migration
  def self.up
    @users = User.all
    @users.each do |user|
      tz = TZInfo::Timezone.get(user.time_zone)
      linked_timezone = tz.instance_variable_get('@linked_timezone')
      name = linked_timezone ? linked_timezone.name : tz.name
      time_zone = TimeZone::MAPPING.index(name)
      user.update_attribute(:time_zone, time_zone)
    end unless @users.empty?
  end

  def self.down
  end
end
