ActionController::Routing::Routes.draw do |map|
    
  map.resources :topics do |topic| 
    topic.resources :posts 
  end
  
  map.home '',                :controller => 'topics',  :action => 'index'
  map.users '/users',         :controller => 'users',   :action => 'index'
    
  map.login     '/login',     :controller => 'users', :action => 'login'
  map.register  '/register',  :controller => 'users', :action => 'new'
  map.logout    '/logout',    :controller => 'users', :action => 'logout'
  
  map.catch_all "*anything", :controller => "topics", :action => "unknown_request"
  
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  map.connect ':controller/:action/:id'
      
end
