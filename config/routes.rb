Rails.application.routes.draw do
  root 'welcome#index'

  get '/users', to: 'users#new', as: '/registration'
  resources :users, only: [:create]
  get '/dashboard', to: 'users#dashboard'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
end
