Rails.application.routes.draw do
  resources :users
  post '/auth/login', to: 'authentication#login'

  # Routes for Posts
  resources :posts do
    resources :likes
    resources :comments
  end

  # Wildcard route for catching undefined routes
  get '/*a', to: 'application#not_found'

  resources :categories do
    resources :sub_categories
  end



end
