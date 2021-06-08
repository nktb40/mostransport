Rails.application.routes.draw do
  root 'about#index'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :isochrones

  resources :stations do
    collection do
      get :get_station_popup
     end
  end

  resources :routes do
    collection do
      get :get_city_routes
      get :get_route_line
     end
  end

  resources :constructor do
    collection do
      get :get_layers
      get :get_city_metrics
     end
  end

  resources :about

  resources :projects do
    collection do
      get :new
      get :get_import_stations_form
      post :import_all_stations
      post :import_station
      post :remove_station
      post :remove_all_stations
      get :get_import_routes_form
      post :import_all_routes
      post :import_route
      post :remove_route
      post :remove_all_routes
      post :create
     end
  end

end
