Rails.application.routes.draw do
  root 'welcome#index'

  resources :users, only: [:create]
  get '/users', to: 'users#new', as: '/registration'
  get '/users/:id', to: 'users#show', as: '/dashboard'

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get '/logout', to: "sessions#destroy"
end
