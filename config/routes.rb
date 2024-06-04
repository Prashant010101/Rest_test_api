Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :actors
    end
  end
  resources :users, param: :_username
  post '/auth/login', to: 'authentication#login'
  get '/*a', to: 'application#not_found'
end
