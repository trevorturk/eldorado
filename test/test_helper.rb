ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  fixtures :all
  
  def login_as(user)
    @request.session[:user_id] = user ? users(user).id : nil
    @request.session[:online_at] = Time.now.utc
  end
  
  def private_site
    settings = Setting.find(:first)
    settings.destroy
  end
  
end
