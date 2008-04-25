ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'home'
  
  map.resources :avatars, :member => { :select => :post, :deselect => :post }
  map.resources :categories, :member => { :confirm_delete => :get }
  map.resources :events
  map.resources :forums, :member => { :confirm_delete => :get }
  map.resources :headers, :member => { :vote_up => :post, :vote_down => :post }
  map.resources :messages
  map.resources :posts, :member => { :quote => :get, :topic => :get }
  map.resources :ranks
  map.resources :settings
  map.resources :subscriptions
  map.resources :themes, :member => { :select => :post, :deselect => :post }
  map.resources :topics, :member => { :show_new => :get }
  map.resources :uploads
  map.resources :users, :member => { :posts => :get, :confirm_delete => :get, :admin => :post, :ban => :get, :remove_ban => :post }
  
  map.search 'search', :controller => 'search', :action => 'index'
  map.refresh_messages 'refresh_messages', :controller => 'messages', :action => 'refresh_messages'
  map.refresh_chatters 'refresh_chatters', :controller => 'messages', :action => 'refresh_chatters'
  
  map.login 'login', :controller => 'users', :action => 'login'
  map.logout 'logout', :controller => 'users', :action => 'logout'
  map.register 'register', :controller => 'users', :action => 'new'
  map.admin 'admin', :controller => 'settings', :action => 'index'
  map.files 'files', :controller => 'uploads', :action => 'index'
  map.chat 'chat', :controller => 'messages', :action => 'index'
  map.forum_root 'forum', :controller => 'forums', :action => 'index'
    
  map.exceptions 'logged_exceptions/:action/:id', :controller => 'logged_exceptions', :action => 'index', :id => nil
  
  map.catch_all '*path', :controller => 'topics', :action => 'unknown_request'
end