ActionController::Routing::Routes.draw do |map|
  map.resources :avatars, :member => { :select => :post, :deselect => :post }
  map.resources :bans
  map.resources :categories
  map.resources :events
  map.resources :forums
  map.resources :headers, :member => { :vote_up => :post, :vote_down => :post }
  map.resources :posts, :member => { :quote => :get }
  map.resources :subscriptions
  map.resources :themes, :member => { :select => :post, :deselect => :post }
  map.resources :topics, :collection => { :show_new => :get }
  map.resources :uploads
  map.resources :users

  map.home  '', :controller => 'home', :action => 'index' 

  map.login '/login', :controller => 'users', :action => 'login'
  map.logout '/logout', :controller => 'users', :action => 'logout'
  map.register '/register', :controller => 'users', :action => 'new'

  map.admin '/admin', :controller => 'admin', :action => 'index'
  map.admin_themes '/admin/themes', :controller => 'admin', :action => 'themes'
  map.admin_import '/admin/import', :controller => 'admin', :action => 'import'

  map.search '/search', :controller => 'search', :action => 'index'  
  map.files_home '/files', :controller => 'uploads', :action => 'index'
  map.forum_home '/forum', :controller => 'forums', :action => 'index'
    
  map.catch_all "*path", :controller => "topics", :action => "unknown_request"
  
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'  
  
end
