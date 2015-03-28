Rails.application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  root to: "users#new"
  resources :users, only: [:create] do
    resources :chains, only: [:show, :new, :create]
  end
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"
end
