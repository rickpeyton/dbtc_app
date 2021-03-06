Rails.application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  root to: "users#new"
  resources :users, only: [:edit, :create, :update] do
    resources :chains, only: [:show, :new, :create]
  end
  resources :links, only: [:create, :destroy]
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"
end
