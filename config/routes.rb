ActionController::Routing::Routes.draw do |map|
  # main web interface 
  map.connect '/', :controller => 'application', :action => 'index'
  map.connect '/upload', :controller => 'application', :action => 'upload'
	map.connect '/learn', :controller => 'application', :action => 'learn'

	# APIS
	# play a specific sound by ID or label	
	map.connect '/play/:id', :controller => 'application', :action => 'play'
	map.connect '/say/:id', :controller => 'application', :action => 'say'
	
	# defaults
	map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
