Rails.application.routes.draw do
  root 'welcome#index'
  resources :users, only: [:new, :create]
  get "/registration", to: "users#new" #<--- should we use this
  get "/login", to: "users#login" #<--- instead of this?
  post "/login", to: "users#authenticate"
end
