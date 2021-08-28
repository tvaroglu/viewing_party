Rails.application.routes.draw do
  root 'welcome#index'

  get '/users', to: 'users#new', as: '/registration'
  resources :users, only: [:create]
  get '/dashboard', to: 'users#dashboard'
  post '/dashboard', to: 'users#search'

  # placeholder, add route once page built
  get '/discover', to: 'welcome#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
end
