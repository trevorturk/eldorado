ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resources :topics
  map.resources :posts
  map.resources :events
  
  map.home  '', :controller => 'home', :action => 'index'  
  map.users '/users', :controller => 'users', :action => 'index'
  map.login '/login', :controller => 'users', :action => 'login'
  map.register '/register', :controller => 'users', :action => 'new'
  map.logout '/logout', :controller => 'users', :action => 'logout'
  map.admin '/admin', :controller => 'admin', :action => 'index'
  map.create_newbies '/newbies/create', :controller => 'newbies', :action => 'create'
  map.destroy_newbies '/newbies/destroy', :controller => 'newbies', :action => 'destroy'
  
  map.catch_all "*path", :controller => "topics", :action => "unknown_request"
  
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  # map.connect ':controller/:action/:id'
      
end
