Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'map#index'

  resources :map do
    collection do
      get :get_routes
      get :get_isochrones
     end
  end

end
