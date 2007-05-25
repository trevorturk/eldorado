namespace :db do
  desc "Installs default values into database"
  task :setup => :environment do
    system "rake db:migrate"
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[RAILS_ENV])
    if (User.count != 0) or (Option.count != 0)
      puts 'Error: Setup can only be performed on an empty database.'
      exit
    end
    @option = Option.new(:site_title => 'El Dorado.org', :site_tagline => 'All an elaborate, unapproachable, unprofitable, retributive joke', :footer_left => '', :footer_right => 'Powered by El Dorado | <a href="http://almosteffortless.com">&aelig;</a>', :newest_user => 'Newest User', :admin_rank => 'Administrator')
    @option.save!
    @category = Category.new(:name => 'Test Category')
    @category.save!
    @forum = @category.forums.build(:name => 'Test Forum', :description => "This is just a test forum")
    @forum.save!
    @user = User.new(:login => 'Guest', :email => 'example@example.com', :password => rand.to_s) 
    @user.save!
    sleep 1
    char = ("a".."z").to_a + ("1".."9").to_a 
    pass = Array.new(6, '').collect{char[rand(char.size)]}.join
    @user = User.new(:login => 'Administrator', :email => 'example@example.com', :password => pass) 
    @user.save!
    @topic = @user.topics.build(:title => 'Test post', :forum_id => 1)
    @topic.save!
    @post = @user.posts.build(:body => 'This is just a test post')
    @post.topic_id = 1
    @post.save!
    puts 'Setup completed successfully'
    puts 'You can now log in with the following information:'
    puts 'Username: Administrator'
    puts "Password: #{pass}"
  end
end
