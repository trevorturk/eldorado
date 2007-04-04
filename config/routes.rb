ActionController::Routing::Routes.draw do |map|
  
  map.resources :avatars, :member => { :select => :post }
  map.resources :categories
  map.resources :events
  map.resources :forums
  map.resources :headers, :member => { :vote_up => :post, :vote_down => :post }
  map.resources :posts
  map.resources :topics
  map.resources :uploads
  map.resources :users

  map.home  '', :controller => 'home', :action => 'index'  

  map.login '/login', :controller => 'users', :action => 'login'
  map.logout '/logout', :controller => 'users', :action => 'logout'
  map.register '/register', :controller => 'users', :action => 'new'

  map.admin '/admin', :controller => 'admin', :action => 'index'
  
  map.calendar_home '/calendar', :controller => 'events', :action => 'index'
  map.files_home '/files', :controller => 'uploads', :action => 'index'
  map.forum_home '/forum', :controller => 'forums', :action => 'index'
    
  map.catch_all "*path", :controller => "topics", :action => "unknown_request"
  
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'  
  
end
