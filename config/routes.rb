Rails.application.routes.draw do
  root 'welcome#index'

  resources :users, only: [:create]
  get '/users/:id', to: 'users#show', as: '/dashboard'
  get '/users', to: 'users#new', as: '/registration'

  get '/login', to: 'users#login'
  post '/login', to: 'users#authenticate'
end
