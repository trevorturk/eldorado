desc "Imports PunBB avatars in public/avatars and associates them with their corresponding users"
task :import_punbb_avatars => :environment do
  ActiveRecord::Base.record_timestamps = false
  @items = Dir.glob(RAILS_ROOT+'/public/avatars/*')
  @items.each do |item|
    @item = Avatar.new
    @item.filename = File.basename(item)
    @item.size = File.size(item)
    @item.content_type = 'image/jpeg' if File.extname(item).downcase == '.jpg'
    @item.content_type = 'image/jpeg' if File.extname(item).downcase == '.jpeg'
    @item.content_type = 'image/gif' if File.extname(item).downcase == '.gif'
    @item.content_type = 'image/png' if File.extname(item).downcase == '.png'
    begin # find corresponding user or use the guest
      @user_id = File.basename(item).chomp(".")
      @item.user_id = User.find(@user_id).id
    rescue
      @item.user_id = 1
    end
    @item.current_user_id = @item.user_id
    @item.created_at = File.mtime(item)
    @item.updated_at = File.mtime(item)
    @item.save!
    User.update_all ['avatar = ?', @item.public_filename], ['id = ?', @item.user_id]
    puts "Importing avatar: #{@item.id}"
  end
  # remove guest user's avatar
  User.update_all ['avatar = ?', nil], ['id = ?', 1] 
  Avatar.update_all ['current_user_id = ?', nil], ['current_user_id = ?', 1] 
  puts 'Import completed successfully.'
end

desc "Imports headers in public/headers and associates them with guest user (id=1)"
task :import_headers => :environment do
  ActiveRecord::Base.record_timestamps = false
  @items = Dir.glob(RAILS_ROOT+'/public/headers/*')
  @items.each do |item|
    @item = Header.new
    @item.filename = File.basename(item)
    @item.size = File.size(item)
    @item.content_type = 'image/jpeg' if File.extname(item).downcase == '.jpg'
    @item.content_type = 'image/jpeg' if File.extname(item).downcase == '.jpeg'
    @item.content_type = 'image/gif' if File.extname(item).downcase == '.gif'
    @item.content_type = 'image/png' if File.extname(item).downcase == '.png'
    @item.user_id = 1
    @item.created_at = File.mtime(item)
    @item.updated_at = File.mtime(item)
    @item.save!
    puts "Importing header: #{@item.id}"
  end
  puts 'Import completed successfully.'
end

desc "Imports files in public/files and associates them with guest user (id=1)"
task :import_files => :environment do
  ActiveRecord::Base.record_timestamps = false
  @items = Dir.glob(RAILS_ROOT+'/public/files/*')
  @items.each do |item|
    @item = Upload.new
    @item.filename = File.basename(item)
    @item.size = File.size(item)
    @item.content_type = 'application/octet-stream'
    @item.content_type = 'video/3gpp2' if File.extname(item).downcase == '.3g2'
    @item.content_type = 'audio/x-aiff' if File.extname(item).downcase == '.aif'
    @item.content_type = 'video/x-ms-asf' if File.extname(item).downcase == '.asf'
    @item.content_type = 'video/x-msvideo' if File.extname(item).downcase == '.avi'
    @item.content_type = 'image/bmp' if File.extname(item).downcase == '.bmp'
    @item.content_type = 'text/css' if File.extname(item).downcase == '.css'
    @item.content_type = 'application/msword' if File.extname(item).downcase == '.doc'
    @item.content_type = 'image/gif' if File.extname(item).downcase == '.gif'
    @item.content_type = 'text/html' if File.extname(item).downcase == '.html'
    @item.content_type = 'image/jpeg' if File.extname(item).downcase == '.jpe'
    @item.content_type = 'image/jpeg' if File.extname(item).downcase == '.jpeg'
    @item.content_type = 'image/jpeg' if File.extname(item).downcase == '.jpg'
    @item.content_type = 'application/x-javascript' if File.extname(item).downcase == '.js'
    @item.content_type = 'audio/midi' if File.extname(item).downcase == '.mid'
    @item.content_type = 'video/quicktime' if File.extname(item).downcase == '.mov'
    @item.content_type = 'audio/mpeg' if File.extname(item).downcase == '.mp3'
    @item.content_type = 'video/mp4' if File.extname(item).downcase == '.mp4'
    @item.content_type = 'video/mpeg' if File.extname(item).downcase == '.mpeg'
    @item.content_type = 'video/mpeg' if File.extname(item).downcase == '.mpg'
    @item.content_type = 'application/pdf' if File.extname(item).downcase == '.pdf'
    @item.content_type = 'image/png' if File.extname(item).downcase == '.png'
    @item.content_type = 'application/x-photoshop' if File.extname(item).downcase == '.psd'
    @item.content_type = 'text/x-python-script' if File.extname(item).downcase == '.py'
    @item.content_type = 'text/x-ruby-script' if File.extname(item).downcase == '.rb'
    @item.content_type = 'text/rtf' if File.extname(item).downcase == '.rtf'
    @item.content_type = 'application/x-shockwave-flash' if File.extname(item).downcase == '.swf'
    @item.content_type = 'image/tiff' if File.extname(item).downcase == '.tif'
    @item.content_type = 'image/tiff' if File.extname(item).downcase == '.tiff'
    @item.content_type = 'text/plain' if File.extname(item).downcase == '.txt'
    @item.content_type = 'audio/x-wav' if File.extname(item).downcase == '.wav'
    @item.content_type = 'video/x-ms-wmv' if File.extname(item).downcase == '.wmv'
    @item.content_type = 'application/vnd.ms-excel' if File.extname(item).downcase == '.xls'
    @item.content_type = 'application/zip' if File.extname(item).downcase == '.zip'
    @item.user_id = 1
    @item.created_at = File.mtime(item)
    @item.updated_at = File.mtime(item)
    @item.save!
    puts "Importing file: #{@item.id}"
  end
  puts 'Import completed successfully.'
end