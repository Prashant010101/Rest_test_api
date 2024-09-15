Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  resources :users
  get 'users/:id', to: 'users#show'
  post '/auth/login', to: 'authentication#login'

  # Routes for Posts
  resources :posts do
    resources :likes
    resources :comments
  end
  resources :follows
  post '/users/verify_otp', to: 'users#verify_otp'

  # Wildcard route for catching undefined routes
  get '/*a', to: 'application#not_found'

  resources :categories do
    resources :sub_categories
  end
end
