ActionController::Routing::Routes.draw do |map|
    
  map.resources :topics do |topic| 
    topic.resources :posts 
  end
  
  map.resources :users
  
  map.home  '', :controller => 'topics', :action => 'index'  
  map.users '/users', :controller => 'users', :action => 'index'
  map.login '/login', :controller => 'users', :action => 'login'
  map.register '/register', :controller => 'users', :action => 'new'
  map.logout '/logout', :controller => 'users', :action => 'logout'
  map.admin '/admin', :controller => 'admin', :action => 'index'
  map.create_newbie '/admin/create_newbie', :controller => 'admin', :action => 'create_newbie'
  map.create_newbie '/admin/delete_newbies', :controller => 'admin', :action => 'delete_newbies'
  
  map.catch_all "*path", :controller => "topics", :action => "unknown_request"
  
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  map.connect ':controller/:action/:id'
      
end
