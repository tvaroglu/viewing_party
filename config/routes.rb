Rails.application.routes.draw do
  root 'welcome#index'

  get '/users', to: 'users#new', as: '/registration'
  resources :users, only: [:create]
  get '/dashboard', to: 'users#dashboard'
  post '/dashboard', to: 'users#search'

  get '/discover', to: 'movies#discover'
  post '/discover', to: 'movies#search'
  get '/popular', to: 'movies#most_popular'
  get '/movie', to: 'movies#show'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
end
