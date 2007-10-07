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
  map.resources :topics, :member => { :show_new => :get }
  map.resources :uploads
  map.resources :users, :member => { :confirm_delete => :get }

  map.root :controller => 'home'
  
  map.login '/login', :controller => 'users', :action => 'login'
  map.logout '/logout', :controller => 'users', :action => 'logout'
  map.register '/register', :controller => 'users', :action => 'new'
  map.search '/search', :controller => 'search', :action => 'index'
  map.files_root '/files', :controller => 'uploads', :action => 'index'
  map.forum_root '/forum', :controller => 'forums', :action => 'index'
  map.forum_admin '/forum/admin', :controller => 'forums', :action => 'admin'
  map.show_posters 'topics/show_posters', :controller => 'topics', :action => 'show_posters'
  
  map.exceptions 'logged_exceptions/:action/:id', :controller => 'logged_exceptions', :action => 'index', :id => nil
  
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'  
  
  map.catch_all "*path", :controller => "topics", :action => "unknown_request"
  
end
