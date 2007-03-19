ActionController::Routing::Routes.draw do |map|
  map.resources :headers
  map.resources :files
  map.resources :events
  map.resources :posts
  map.resources :topics
  map.resources :users
  
  map.home  '', :controller => 'home', :action => 'index'  

  map.login '/login', :controller => 'users', :action => 'login'
  map.logout '/logout', :controller => 'users', :action => 'logout'
  map.register '/register', :controller => 'users', :action => 'new'

  map.admin '/admin', :controller => 'admin', :action => 'index'
  
  map.create_newbies '/newbies/create', :controller => 'newbies', :action => 'create'
  map.destroy_newbies '/newbies/destroy', :controller => 'newbies', :action => 'destroy'
  
  map.destroy_newbies '/files/upload', :controller => 'files', :action => 'upload'
      
  map.catch_all "*path", :controller => "topics", :action => "unknown_request"
  
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  # map.connect ':controller/:action/:id'
end
