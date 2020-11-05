Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'about#index'

  resources :isochrones do
    collection do
      get :get_routes
      get :get_changes_routes
      get :get_isochrones
      get :get_metrics
     end
  end

  resources :routes do
    collection do
      get :get_city_routes
     end
  end

  resources :constructor do
    collection do
      get :get_layers
     end
  end

  resources :about

end
