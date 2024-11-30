Rails.application.routes.draw do

  # Custom Routes
  post '/users/verify_otp', to: 'users#verify_otp'
  get '/auth/:provider/callback', to: 'sessions#omniauth'
  get 'users/:id', to: 'users#show'
  post '/auth/login', to: 'authentication#login'

  resources :users, only: [:index, :show, :update, :destroy]

  namespace :otp do
    post :send_otp
    post :resend_otp
  end

  namespace :registration do
    post :verify_otp_and_activate
  end

  # Routes for Posts
  resources :posts do
    resources :likes
    resources :comments
  end
  resources :follows

  # Wildcard route for catching undefined routes
  get '/*a', to: 'application#not_found'

  resources :categories do
    resources :sub_categories
  end
end
