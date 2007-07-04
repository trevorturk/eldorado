desc "Imports PunBB avatars in public/avatars and associates them with their corresponding users"
task :import_punbb_avatars => :environment do
  #
  # AVATARS
  #
  @avatars = Dir.glob(RAILS_ROOT+'/public/avatars/*')
  @avatars.each do |item|
    @avatar = Avatar.new
    @avatar.filename = File.basename(item)
    @avatar.size = File.size(item)
    @avatar.content_type = 'image/jpeg' if File.extname(item) == ".jpg"
    @avatar.content_type = 'image/jpeg' if File.extname(item) == ".jpeg"
    @avatar.content_type = 'image/gif' if File.extname(item) == ".gif"
    @avatar.content_type = 'image/png' if File.extname(item) == ".png"
    begin # find corresponding user or use the guest
      @user_id = File.basename(item).chomp(".")
      @avatar.user_id = User.find(@user_id).id
    rescue
      @avatar.user_id = 1
    end
    @avatar.current_user_id = @avatar.user_id
    @avatar.save!
    User.update_all ['avatar_id = ?', @avatar.id], ['id = ?', @avatar.user_id]
  end
  # remove guest user's avatar
  User.update_all ['avatar_id = ?', nil], ['id = ?', 1] 
  Avatar.update_all ['current_user_id = ?', nil], ['current_user_id = ?', 1] 
  #
  # DONE
  #
  puts 'Import completed successfully.'
end


