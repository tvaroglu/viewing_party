Rails.application.routes.draw do
  root 'welcome#index'
  resources :users, only: [:new, :create]
  get "/login", to: "users#login"
  post "/login", to: "users#authenticate"
end
