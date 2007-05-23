namespace :db do
  desc "Installs default values into database"
  task :setup => :environment do
    system "rake db:migrate"
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[RAILS_ENV])
    if (User.count != 0) or (Option.count != 0)
      puts 'Error: Setup can only be performed on an empty database.'
      exit
    end
    @option = Option.new
      @option.site_title = 'El Dorado.org'
      @option.site_tagline = 'All an elaborate, unapproachable, unprofitable, retributive joke'
      @option.footer_left = ''
      @option.footer_right = 'Powered by El Dorado | <a href="http://almosteffortless.com">&aelig;</a>'
      @option.newest_user = 'Newest User'
      @option.admin_rank = 'Administrator'
      @option.save!
    @user = User.new
      @user.login = 'Guest'
      @user.email = 'example@example.com'
      @user.password_hash = User.encrypt(rand.to_s) 
      @user.save!
    sleep 1
    @user = User.new
      @user.login = 'Administrator'
      @user.email = 'example@example.com'
      @user.password = 'admin'
        chars = ("a".."z").to_a + ("1".."9").to_a 
        pass = Array.new(6, '').collect{chars[rand(chars.size)]}.join
      @user.password_hash = User.encrypt(pass) 
      @user.save!
    puts 'Setup completed successfully'
    puts 'You can now log in with the following information:'
    puts 'Username: Administrator'
    puts "Password: #{pass}"
  end
end