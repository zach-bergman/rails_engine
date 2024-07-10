Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  
  namespace :api do
    namespace :v1 do
    get "/merchants/find", to: "merchants_find#index"
      resources :merchants, only: [:index, :show] do  
        resources :items, only: [:index, :show], controller: "merchants/items"
      end
      resources :items do
        resources :merchant, only: [:index], controller: "items/merchant"
      end
    end
  end
end
