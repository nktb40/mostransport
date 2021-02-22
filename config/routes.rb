Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'about#index'

  resources :isochrones

  resources :routes do
    collection do
      get :get_city_routes
     end
  end

  resources :constructor do
    collection do
      get :get_layers
      get :get_station_info
      get :get_city_metrics
     end
  end

  resources :about

end
