Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'isochrones#index'

  resources :isochrones do
    collection do
      get :get_routes
      get :get_changes_routes
      get :get_isochrones
      get :get_metrics
     end
  end

  resources :routes

  resources :constructor

end
